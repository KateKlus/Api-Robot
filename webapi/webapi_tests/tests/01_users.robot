*** Settings ***
Documentation     Тестирование работы OAPI с объектами user
Test Timeout      1 minute
Library  requests
Library  Collections
Library  DatabaseLibrary
Library  OperatingSystem
Library  json

Resource  ./variables.robot
Suite Setup       Connect To Database Using Custom Params  sqlite3  database='../../../db.sqlite3'
Suite Teardown    Disconnect From Database

*** Variables ***
${USER_URL}
${USER_NAME}  AutotestUserg
*** Test Cases ***
Test geting list of users
    [Tags]    user
    [Documentation]  Получение списка пользователей
    ${actual}  Get  http://127.0.0.1:8000/api/users/
    Should Be Equal  ${actual.status_code}    ${200}
    @{json}  Set Variable  ${actual.json()}
    ${actualList}  Create actual result list  @{json}
    @{db}    Query  SELECT * FROM auth_user;
    ${expectedlList}  Create expected result lis  @{db}
    should be equal  ${actualList}  ${expectedlList}

Test creating new user
    [Tags]    user
    [Documentation]  Создание пользователя
    ${json}  Create user
    ${username}  Get From Dictionary  ${json}  username
    ${user_url}  Get From Dictionary  ${json}  url
    ${username_db}  Get user by name from db  ${username}
    SHOULD BE EQUAL  ${username}  ${username_db}
    Delete user by url  ${user_url}

Test deleting user
    [Tags]    user
    [Documentation]  Удаление пользователя
    ${json}  Create user
    ${user_url}  Get From Dictionary  ${json}  url
    ${response}  Delete user by url  ${user_url}
    ${response}  Should Be Equal  ${response.status_code}    ${204}

*** Keywords ***
Create user
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=Token 90f65337e4fe9d821bd4a80b04cb6bf331bb60fe
    ${data}  Create Dictionary  username=${USER_NAME}  email=AutotestUser@mail.ru
    ${req_json}    Json.Dumps    ${data}
    ${response}  Post  http://127.0.0.1:8000/api/users/  data=${req_json}  headers=${headers}
    ${json}  Set Variable  ${response.json()}
    [Return]  ${json}

Delete user by url
    [Arguments]  ${url}
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=Token 90f65337e4fe9d821bd4a80b04cb6bf331bb60fe
    ${response}  Delete  url=${url}  headers=${headers}
    [Return]  ${response}

Create actual result list
    [Arguments]  @{json}
    ${result}  create list
    :FOR    ${ELEMENT}    IN    @{json}
    \    Log    ${ELEMENT}
    \    ${username}  Get From Dictionary  ${ELEMENT}  username
    \    APPEND TO LIST  ${result}  ${username}
    sort list  ${result}
    Log  ${result}
    [Return]  ${result}

Create expected result lis
    [Arguments]  @{db}
    ${result}  create list
    :FOR    ${ELEMENT}    IN    @{db}
    \    Log    ${ELEMENT}
    \    APPEND TO LIST  ${result}  ${ELEMENT[4]}
    sort list  ${result}
    Log  ${result}
    [Return]  ${result}

Get user by name from api
    [Arguments]  ${name}
    ${actual}  Get  http://127.0.0.1:8000/api/users/
    Should Be Equal  ${actual.status_code}    ${200}
    @{json}  Set Variable  ${actual.json()}
    ${result}  create list
    :FOR    ${ELEMENT}    IN     @{json}
    \    Run Keyword If 	${ELEMENT} != ${name} 	Continue For Loop
    \    APPEND TO LIST  ${result}  ${ELEMENT[2]}
    Log  ${result}
    [Return]  ${result}

Get user by name from db
    [Arguments]  ${name}
    ${sql}  catenate
    ...  SELECT username FROM auth_user
    ...  Where username="${name}"
    ${db}    Query  ${sql}
    ${username_db}  Get From List  ${db}  0
    ${username_db}    Convert To List    ${username_db}
    ${username_db}  Get From List  ${username_db}  0
    Log  ${db}
    [Return]  ${username_db}

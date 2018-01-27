*** Settings ***
Documentation     Тестирование работы OAPI с объектами event
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
${USER_URL}  http://127.0.0.1:8000/api/users/1/
${USER_NAME}  AutotestUserg
${TOKEN}  Token 90f65337e4fe9d821bd4a80b04cb6bf331bb60fe
*** Test Cases ***
Test geting list of events
    [Tags]    event
    [Documentation]  Получение списка событий
    ${actual}  Get  http://127.0.0.1:8000/api/events/
    Should Be Equal  ${actual.status_code}    ${200}
    @{json}  Set Variable  ${actual.json()}
    ${actualList}  Create actual result list  @{json}
    @{db}    Query  SELECT * FROM webapi_event;
    ${expectedlList}  Create expected result lis  @{db}
    should be equal  ${actualList}  ${expectedlList}

Test creating new user
    [Tags]    event
    [Documentation]  Создание события
    ${json}  Create event
    ${event_title}  Get From Dictionary  ${json}  title
    ${event_url}  Get From Dictionary  ${json}  url
    ${event_title_db}  Get user by name from db  ${event_title}
    SHOULD BE EQUAL  ${event_title}  ${event_title_db}
    Delete event by url  ${event_url}

Test deleting user
    [Tags]    event
    [Documentation]  Удаление события
    ${json}  Create event
    ${event_url}  Get From Dictionary  ${json}  url
    ${response}  Delete event by url  ${event_url}
    ${response}  Should Be Equal  ${response.status_code}    ${204}

*** Keywords ***
Create event
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=${TOKEN}
    ${data}  Create Dictionary  title=title  text=text  author=${USER_URL}  hazard_lvl=Критический  event_date=2018-01-13 10:47:43
    ${req_json}    Json.Dumps    ${data}
    ${response}  Post  http://127.0.0.1:8000/api/event/  data=${req_json}  headers=${headers}
    ${json}  Set Variable  ${response.json()}
    [Return]  ${json}

Delete event by url
    [Arguments]  ${url}
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=${TOKEN}
    ${response}  Delete  url=${url}  headers=${headers}
    [Return]  ${response}

Create actual result list
    [Arguments]  @{json}
    ${result}  create list
    :FOR    ${ELEMENT}    IN    @{json}
    \    Log    ${ELEMENT}
    \    ${title}  Get From Dictionary  ${ELEMENT}  title
    \    APPEND TO LIST  ${result}  ${title}
    sort list  ${result}
    Log  ${result}
    [Return]  ${result}

Create expected result lis
    [Arguments]  @{db}
    ${result}  create list
    :FOR    ${ELEMENT}    IN    @{db}
    \    Log    ${ELEMENT}
    \    APPEND TO LIST  ${result}  ${ELEMENT[5]}
    sort list  ${result}
    Log  ${result}
    [Return]  ${result}

Get event by name from api
    [Arguments]  ${name}
    ${actual}  Get  http://127.0.0.1:8000/api/event/
    Should Be Equal  ${actual.status_code}    ${200}
    @{json}  Set Variable  ${actual.json()}
    ${result}  create list
    :FOR    ${ELEMENT}    IN     @{json}
    \    Run Keyword If 	${ELEMENT} != ${name} 	Continue For Loop
    \    APPEND TO LIST  ${result}  ${ELEMENT[2]}
    Log  ${result}
    [Return]  ${result}

Get event by name from db
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

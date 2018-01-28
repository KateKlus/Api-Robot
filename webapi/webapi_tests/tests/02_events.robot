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
${EVENT_URL}  http://127.0.0.1:8000/api/events/
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
    log  ${actualList}
    @{db}    Query  SELECT * FROM webapi_event;
    ${expectedlList}  Create expected result lis  @{db}
    log  ${expectedlList}
    should be equal  ${actualList}  ${expectedlList}

Test geting not exist event
    [Tags]    event
    [Documentation]  Получение не существующего события
    ${actual}  Get  http://127.0.0.1:8000/api/events/-1/
    Should Be Equal  ${actual.status_code}    ${404}
    ${json}  Set Variable  ${actual.json()}
    ${detail}  Get From Dictionary  ${json}  detail
    Log  ${detail}
    Should Be Equal  ${detail}  ${NOT_FOUND_MSG}

Test creating new event
    [Tags]    event
    [Documentation]  Создание события
    ${json}  Create event
    ${event_title}  Get From Dictionary  ${json}  title
    Log  ${event_title}
    ${event_id}  Get From Dictionary  ${json}  id
    ${event_title_db}  Get event by id from db  ${event_id}
    Log  ${event_title_db}
    SHOULD BE EQUAL  ${event_title}  ${event_title_db}
    Delete event by url  ${EVENT_URL}${event_id}/

Test deleting event
    [Tags]    event
    [Documentation]  Удаление события
    ${json}  Create event
    ${event_id}  Get From Dictionary  ${json}  id
    ${response}  Delete event by url  ${event_url}${event_id}/

*** Keywords ***
Create event
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=${TOKEN}
    ${data}  Create Dictionary  title=title  text=text  author=${USER_URL}  hazard_lvl=Критический  event_date=2018-01-13 10:47:43
    ${req_json}    Json.Dumps    ${data}
    ${response}  Post  http://127.0.0.1:8000/api/events/  data=${req_json}  headers=${headers}
    ${json}  Set Variable  ${response.json()}
    [Return]  ${json}

Delete event by url
    [Arguments]  ${url}
    ${headers}  Create Dictionary  Content-Type=Application/json  Authorization=${TOKEN}
    ${response}  Delete  url=${url}  headers=${headers}
    Should Be Equal  ${response.status_code}    ${204}
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
    ${actual}  Get  http://127.0.0.1:8000/api/events/
    Should Be Equal  ${actual.status_code}    ${200}
    @{json}  Set Variable  ${actual.json()}
    ${result}  create list
    :FOR    ${ELEMENT}    IN     @{json}
    \    Run Keyword If 	${ELEMENT} != ${name} 	Continue For Loop
    \    APPEND TO LIST  ${result}  ${ELEMENT[2]}
    Log  ${result}
    [Return]  ${result}

Get event by id from db
    [Arguments]  ${id}
    ${sql}  catenate
    ...  SELECT title FROM webapi_event
    ...  Where id="${id}"
    ${db}    Query  ${sql}
    ${title_db}  Get From List  ${db}  0
    ${title_db}    Convert To List    ${title_db}
    ${title_db}  Get From List  ${title_db}  0
    Log  ${db}
    [Return]  ${title_db}

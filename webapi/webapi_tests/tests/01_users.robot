*** Settings ***
Documentation     Примеры GET-запросов.
Test Timeout      1 minute
Library  requests
Library  Collections
Library  DatabaseLibrary
Library  OperatingSystem
Suite Setup       Connect To Database Using Custom Params  sqlite3  database='../../../db.sqlite3'
Suite Teardown    Disconnect From Database

*** Variables ***
${DBName}         db.sqlite3
${DBHost}         127.0.0.1
${DBPass}         ""
${DBPort}         8000

*** Test Cases ***
simpleRequest
    ${result} =  Get  http://echo.jsontest.com/framework/robot-framework/api/rest
    Should Be Equal  ${result.status_code}  ${200}
    ${json} =  Set Variable  ${result.json()}
    ${framework} =  Get From Dictionary  ${json}  framework
    Should Be Equal  ${framework}  robot-framework
    ${api} =  Get From Dictionary  ${json}  api
    Should Be Equal  ${api}  rest

Retrieve records from person table
    [Tags]    db
    ${output} =    Execute SQL String    SELECT * FROM auth_user;
    Log    ${output}
    Should Be Equal As Strings    ${output}    None
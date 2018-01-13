*** Settings ***
Documentation     Примеры GET-запросов.
Test Timeout      1 minute
Library  requests
Library  Collections
Library  DatabaseLibrary
Library  OperatingSystem
Resource  ./variables.robot
Suite Setup       Connect To Database Using Custom Params  sqlite3  database='../../../db.sqlite3'
Suite Teardown    Disconnect From Database

*** Variables ***
${DBName}         db.sqlite3
${DBHost}         127.0.0.1
${DBPass}         ""
${DBPort}         8000

*** Test Cases ***
Get list of users
    ${actual} =  Get  http://127.0.0.1:8000/users/
    Should Be Equal  ${actual.status_code}    ${200}
    ${json} =  Set Variable  ${actual.json()}
    ${expected} =    Query  SELECT * FROM auth_user;
    should be equal  ${actual}  ${expected}
    #${json} =  Set Variable  ${result.json()}
    #${framework} =  Get From Dictionary  ${json}  framework
    #Should Be Equal  ${framework}  robot-framework
    #${api} =  Get From Dictionary  ${json}  api
    #Should Be Equal  ${api}  rest

Get list of users from DB
    [Tags]    db
    ${output} =    Query    SELECT * FROM auth_user;
    Log    ${output}
    Should Be Equal As Strings    ${output}    None
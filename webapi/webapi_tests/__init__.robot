*** Settings ***
Documentation     Примеры тестов для тестирования REST API.
...
...               == Зависимости ==
...               - [ https://github.com/dmizverev/robot-framework-library/blob/master/library/JsonValidator.py | JsonValidator ]
...               - [ https://github.com/dmizverev/robot-framework-library/blob/master/library/OracleDB.py | OracleDb]
...               - [ https://github.com/bulkan/robotframework-requests | RequestsLibrary]
...               - [ http://robotframework.org/robotframework/latest/libraries/Collections.html | Collections]
Resource          ..${/}keywords${/}common.robot
Suite Setup       Suite_Setup
Suite Teardown    Suite_Teardown
Force Tags        demo
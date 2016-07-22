SELECT        LTRIM(RTRIM(UUT_RESULT_TEMP.STATION_ID)) AS STATION_ID, LTRIM(RTRIM(UUT_RESULT_TEMP.BATCH_SERIAL_NUMBER)) AS BATCH_SERIAL_NUMBER, LTRIM(RTRIM(UUT_RESULT_TEMP.UUT_SERIAL_NUMBER)) AS UUT_SERIAL_NUMBER, UUT_RESULT_TEMP.TEST_SOCKET_INDEX, 
                         LTRIM(RTRIM(UUT_RESULT_TEMP.USER_LOGIN_NAME)) AS USER_LOGIN_NAME, UUT_RESULT_TEMP.START_DATE_TIME, UUT_RESULT_TEMP.EXECUTION_TIME, UUT_RESULT_TEMP.UUT_ERROR_CODE, LTRIM(RTRIM(UUT_RESULT_TEMP.UUT_STATUS)) AS UUT_STATUS, 
                         LTRIM(RTRIM(UUT_RESULT_TEMP.INTERFACE_JIG)) AS INTERFACE_JIG, LTRIM(RTRIM(UUT_RESULT_TEMP.UUT_ERROR_MESSAGE)) AS UUT_ERROR_MESSAGE, LTRIM(RTRIM(UUT_RESULT_TEMP.PRODUCT)) AS PRODUCT, STEP_RESULT_TEMP.STEP_PARENT, LTRIM(RTRIM(STEP_RESULT_TEMP.STEP_TYPE)) AS STEP_TYPE, 
                         STEP_RESULT_TEMP.ORDER_NUMBER, LTRIM(RTRIM(STEP_RESULT_TEMP.STEP_NAME)) AS STEP_NAME, LTRIM(RTRIM(STEP_RESULT_TEMP.STEP_GROUP)) AS STEP_GROUP, STEP_RESULT_TEMP.STEP_INDEX, LTRIM(RTRIM(STEP_RESULT_TEMP.STEP_ID)) AS STEP_ID, 
                         LTRIM(RTRIM(STEP_RESULT_TEMP.STATUS)) AS STATUS, LTRIM(RTRIM(STEP_RESULT_TEMP.REPORT_TEXT)) AS REPORT_TEXT, STEP_RESULT_TEMP.ERROR_CODE, LTRIM(RTRIM(STEP_RESULT_TEMP.ERROR_MESSAGE)) AS ERROR_MESSAGE, STEP_RESULT_TEMP.CAUSED_SEQFAIL, 
                         STEP_RESULT_TEMP.MODULE_TIME, STEP_RESULT_TEMP.TOTAL_TIME, STEP_RESULT_TEMP.NUM_PASSED, STEP_RESULT_TEMP.NUM_FAILED, STEP_RESULT_TEMP.NUM_LOOPS, 
                         STEP_RESULT_TEMP.ENDING_LOOP_INDEX, STEP_RESULT_TEMP.LOOP_INDEX, STEP_RESULT_TEMP.INTERACTIVE_EXENUM, LTRIM(RTRIM(STEP_RESULT_TEMP.RESULT_TYPE)) AS RESULT_TYPE, STEP_RESULT_TEMP.DATA, 
                         STEP_RESULT_TEMP.HIGH_LIMIT, STEP_RESULT_TEMP.LOW_LIMIT, LTRIM(RTRIM(STEP_RESULT_TEMP.UNITS)) AS UNITS
FROM            UUT_RESULT_TEMP LEFT OUTER JOIN
                         STEP_RESULT_TEMP ON STEP_RESULT_TEMP.UUT_RESULT = UUT_RESULT_TEMP.ID
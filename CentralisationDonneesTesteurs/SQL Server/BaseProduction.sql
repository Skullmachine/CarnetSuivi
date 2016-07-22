USE master
GO

--Vérification que la database n'existe pas
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'Production' )
    ALTER DATABASE Production SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
IF EXISTS ( SELECT * FROM sys.databases WHERE name = 'Production' )
    DROP DATABASE Production 
GO
CREATE DATABASE [Production]
GO

sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO

ALTER DATABASE Production SET RECOVERY SIMPLE
GO

USE Production
GO

IF OBJECT_ID('dbo.UUT_RESULT') IS NULL
CREATE TABLE UUT_RESULT (
ID	uniqueidentifier PRIMARY KEY,
STATION_ID	varchar(255),
BATCH_SERIAL_NUMBER	varchar(255),
TEST_SOCKET_INDEX	int,
UUT_SERIAL_NUMBER	varchar(255),
USER_LOGIN_NAME	varchar(255),
START_DATE_TIME	datetime,
EXECUTION_TIME	float,
UUT_STATUS	varchar(32),
UUT_ERROR_CODE	int,
UUT_ERROR_MESSAGE	varchar(255),
PART_NUMBER	varchar(255),
TSR_FILE_NAME	varchar(255),
TSR_FILE_ID	varchar(64),
TSR_FILE_CLOSED	bit)
GO

IF OBJECT_ID('dbo.STEP_RESULT') IS NULL
CREATE TABLE STEP_RESULT (
ID	uniqueidentifier PRIMARY KEY,
UUT_RESULT	uniqueidentifier,
STEP_PARENT	uniqueidentifier,
ORDER_NUMBER	int,
STEP_NAME	varchar(255),
STEP_TYPE	varchar(255),
STEP_GROUP	varchar(32),
STEP_INDEX	int,
STEP_ID	varchar(32),
STATUS	varchar(255),
REPORT_TEXT	varchar(255),
ERROR_CODE	int,
ERROR_MESSAGE	varchar(255),
CAUSED_SEQFAIL	bit,
MODULE_TIME	float,
TOTAL_TIME	float,
NUM_LOOPS	int,
NUM_PASSED	int,
NUM_FAILED	int,
ENDING_LOOP_INDEX	int,
LOOP_INDEX	int,
INTERACTIVE_EXENUM	int,
CONSTRAINT STEP_RESULT_UUT_RESULT_FK FOREIGN KEY (UUT_RESULT) REFERENCES UUT_RESULT (ID))
GO

IF OBJECT_ID('dbo.STEP_SEQCALL') IS NULL
CREATE TABLE STEP_SEQCALL (
ID	uniqueidentifier PRIMARY KEY,
STEP_RESULT	uniqueidentifier,
SEQUENCE_NAME	varchar(255),
SEQUENCE_FILE_PATH	varchar(1024),
CONSTRAINT STEP_SEQCALL_STEP_RESULT_FK FOREIGN KEY (STEP_RESULT) REFERENCES STEP_RESULT (ID))
GO

IF OBJECT_ID('dbo.STEP_NUMERICLIMIT1') IS NULL
CREATE TABLE STEP_NUMERICLIMIT1 (
ID	uniqueidentifier PRIMARY KEY,
STEP_RESULT	uniqueidentifier,
PROP_PARENT	uniqueidentifier,
ORDER_NUMBER	int,
NAME	varchar(255),
PATH	varchar(1024),
CATEGORY	int,
TYPE_VALUE	int,
TYPE_NAME	varchar(255),
DISPLAY_FORMAT	varchar(32),
DATA	float,
CONSTRAINT STEP_NUMERICLIMIT1_STEP_RESULT_FK FOREIGN KEY (STEP_RESULT) REFERENCES STEP_RESULT (ID))
GO

IF OBJECT_ID('dbo.STEP_NUMERICLIMIT2') IS NULL
CREATE TABLE STEP_NUMERICLIMIT2 (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
COMP_OPERATOR	varchar(32),
HIGH_LIMIT	float,
LOW_LIMIT	float,
UNITS	varchar(255),
STATUS	varchar(255),
CONSTRAINT STEP_NUMERICLIMIT2_STEP_NUMERICLIMIT1_FK FOREIGN KEY (PROP_RESULT) REFERENCES STEP_NUMERICLIMIT1 (ID))
GO

IF OBJECT_ID('dbo.PROP_RESULT') IS NULL
CREATE TABLE PROP_RESULT (
ID	uniqueidentifier PRIMARY KEY,
STEP_RESULT	uniqueidentifier,
PROP_PARENT	uniqueidentifier,
ORDER_NUMBER	int,
NAME	varchar(255),
PATH	varchar(255),
CATEGORY	int,
TYPE_VALUE	int,
TYPE_NAME	varchar(255),
DISPLAY_FORMAT	varchar(32),
DATA	varchar(255),
CONSTRAINT PROP_RESULT_STEP_RESULT_FK FOREIGN KEY (STEP_RESULT) REFERENCES STEP_RESULT (ID))
GO

IF OBJECT_ID('dbo.PROP_MULTINUMERIC1') IS NULL
CREATE TABLE PROP_MULTINUMERICLIMIT1 (
ID	uniqueidentifier PRIMARY KEY,
STEP_RESULT	uniqueidentifier,
PROP_PARENT	uniqueidentifier,
ORDER_NUMBER	int,
NAME	varchar(255),
PATH	varchar(255),
CATEGORY	int,
TYPE_VALUE	int,
TYPE_NAME	varchar(255),
DISPLAY_FORMAT	varchar(32),
DATA	varchar(255),
CONSTRAINT PROP_MULTINUMERICLIMIT1_STEP_RESULT_FK FOREIGN KEY (STEP_RESULT) REFERENCES STEP_RESULT (ID),
CONSTRAINT PROP_MULTINUMERICLIMIT1_PROP_RESULT_FK FOREIGN KEY (PROP_PARENT) REFERENCES PROP_RESULT (ID))
GO

IF OBJECT_ID('dbo.PROP_MULTINUMERIC2') IS NULL
CREATE TABLE PROP_MULTINUMERICLIMIT2 (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
COMP_OPERATOR	varchar(32),
HIGH_LIMIT	float,
LOW_LIMIT	float,
UNITS	varchar(255),
STATUS	varchar(255),
CONSTRAINT PROP_MULTINUMERICLIMIT2_PROP_MULTINUMERICLIMIT1_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_MULTINUMERICLIMIT1 (ID))
GO

IF OBJECT_ID('dbo.PROP_ANALOGWAVEFORM') IS NULL
CREATE TABLE PROP_ANALOGWAVEFORM (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
INITIAL_T	datetime,
DELTA_T	float,
INITIAL_X	float,
DELTA_X	float,
UPPER_BOUNDS	varchar(32),
LOWER_BOUNDS	varchar(32),
DATA_FORMAT	varchar(32),
DATA	image,
ATTRIBUTES	varchar(1024),
CONSTRAINT PROP_ANALOGWAVEFORM_PROP_RESULT_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_RESULT (ID))
GO

IF OBJECT_ID('dbo.PROP_DIGITALWAVEFORM') IS NULL
CREATE TABLE PROP_DIGITALWAVEFORM (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
INITIAL_T	datetime,
DELTA_T	float,
UPPER_BOUNDS	varchar(32),
LOWER_BOUNDS	varchar(32),
TRANSITIONS	image,
DATA	image,
ATTRIBUTES	varchar(1024),
CONSTRAINT PROP_DIGITALWAVEFORM_PROP_RESULT_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_RESULT (ID))
GO

IF OBJECT_ID('dbo.IVIWAVE') IS NULL
CREATE TABLE PROP_IVIWAVE (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
INITIAL_X	float,
DELTA_X	float,
UPPER_BOUNDS	varchar(32),
LOWER_BOUNDS	varchar(32),
DATA_FORMAT	varchar(32),
DATA	image,
ATTRIBUTES	varchar(1024),
CONSTRAINT PROP_IVIWAVE_PROP_RESULT_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_RESULT (ID))
GO

IF OBJECT_ID('dbo.IVIWAVEPAIR') IS NULL
CREATE TABLE PROP_IVIWAVEPAIR (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
INITIAL_X	float,
DELTA_X	float,
UPPER_BOUNDS	varchar(32),
LOWER_BOUNDS	varchar(32),
DATA_FORMAT	varchar(32),
DATA	image,
ATTRIBUTES	varchar(1024),
CONSTRAINT PROP_IVIWAVEPAIR_PROP_RESULT_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_RESULT (ID))
GO

IF OBJECT_ID('dbo.PROP_BINARY') IS NULL
CREATE TABLE PROP_BINARY (
ID	uniqueidentifier PRIMARY KEY,
PROP_RESULT	uniqueidentifier,
UPPER_BOUNDS	varchar(32),
LOWER_BOUNDS	varchar(32),
DATA_FORMAT	varchar(32),
DATA	image,
CONSTRAINT PROP_BINARY_PROP_RESULT_FK FOREIGN KEY (PROP_RESULT) REFERENCES PROP_RESULT (ID))
GO

CREATE PROCEDURE InsertUUTResult
@pID uniqueidentifier,
@pSTATION_ID varchar(255),
@pBATCH_SERIAL_NUMBER varchar(255),
@pTEST_SOCKET_INDEX int,
@pUUT_SERIAL_NUMBER varchar(255),
@pUSER_LOGIN_NAME varchar(255),
@pSTART_DATE_TIME datetime,
@pEXECUTION_TIME float,
@pUUT_STATUS varchar(32),
@pUUT_ERROR_CODE int,
@pUUT_ERROR_MESSAGE varchar(255),
@pPART_NUMBER varchar(255),
@pTSR_FILE_NAME varchar(255),
@pTSR_FILE_ID varchar(64),
@pTSR_FILE_CLOSED bit
AS
INSERT INTO UUT_RESULT ( ID,STATION_ID,BATCH_SERIAL_NUMBER,TEST_SOCKET_INDEX,UUT_SERIAL_NUMBER,USER_LOGIN_NAME,START_DATE_TIME,EXECUTION_TIME,UUT_STATUS,UUT_ERROR_CODE,UUT_ERROR_MESSAGE,PART_NUMBER,TSR_FILE_NAME,TSR_FILE_ID,TSR_FILE_CLOSED)
VALUES (
@pID,
@pSTATION_ID,
@pBATCH_SERIAL_NUMBER,
@pTEST_SOCKET_INDEX,
@pUUT_SERIAL_NUMBER,
@pUSER_LOGIN_NAME,
@pSTART_DATE_TIME,
@pEXECUTION_TIME,
@pUUT_STATUS,
@pUUT_ERROR_CODE,
@pUUT_ERROR_MESSAGE,
@pPART_NUMBER,
@pTSR_FILE_NAME,
@pTSR_FILE_ID,
@pTSR_FILE_CLOSED)
GO

CREATE PROCEDURE InsertStepResult
@pID uniqueidentifier,
@pUUT_RESULT uniqueidentifier,
@pSTEP_PARENT uniqueidentifier,
@pORDER_NUMBER int,
@pSTEP_NAME varchar(255),
@pSTEP_TYPE varchar(255),
@pSTEP_GROUP varchar(32),
@pSTEP_INDEX int,
@pSTEP_ID varchar(32),
@pSTATUS varchar(255),
@pREPORT_TEXT varchar(255),
@pERROR_CODE int,
@pERROR_MESSAGE varchar(255),
@pCAUSED_SEQFAIL bit,
@pMODULE_TIME float,
@pTOTAL_TIME float,
@pNUM_LOOPS int,
@pNUM_PASSED int,
@pNUM_FAILED int,
@pENDING_LOOP_INDEX int,
@pLOOP_INDEX int,
@pINTERACTIVE_EXENUM int
AS
INSERT INTO STEP_RESULT ( ID,UUT_RESULT,STEP_PARENT,ORDER_NUMBER,STEP_NAME,STEP_TYPE,STEP_GROUP,STEP_INDEX,STEP_ID,STATUS,REPORT_TEXT,ERROR_CODE,ERROR_MESSAGE,CAUSED_SEQFAIL,MODULE_TIME,TOTAL_TIME,NUM_LOOPS,NUM_PASSED,NUM_FAILED,ENDING_LOOP_INDEX,LOOP_INDEX,INTERACTIVE_EXENUM)
VALUES (
@pID,
@pUUT_RESULT,
@pSTEP_PARENT,
@pORDER_NUMBER,
@pSTEP_NAME,
@pSTEP_TYPE,
@pSTEP_GROUP,
@pSTEP_INDEX,
@pSTEP_ID,
@pSTATUS,
@pREPORT_TEXT,
@pERROR_CODE,
@pERROR_MESSAGE,
@pCAUSED_SEQFAIL,
@pMODULE_TIME,
@pTOTAL_TIME,
@pNUM_LOOPS,
@pNUM_PASSED,
@pNUM_FAILED,
@pENDING_LOOP_INDEX,
@pLOOP_INDEX,
@pINTERACTIVE_EXENUM)
GO

CREATE PROCEDURE InsertStepSeqCall
@pID uniqueidentifier,
@pSTEP_RESULT uniqueidentifier,
@pSEQUENCE_NAME varchar(255),
@pSEQUENCE_FILE_PATH varchar(1024)
AS
INSERT INTO STEP_SEQCALL ( ID,STEP_RESULT,SEQUENCE_NAME,SEQUENCE_FILE_PATH)
VALUES (
@pID,
@pSTEP_RESULT,
@pSEQUENCE_NAME,
@pSEQUENCE_FILE_PATH)
GO

CREATE PROCEDURE InsertNumericLimitStep
@pID uniqueidentifier,
@pSTEP_RESULT uniqueidentifier,
@pPROP_PARENT uniqueidentifier,
@pORDER_NUMBER int,
@pNAME varchar(255),
@pPATH varchar(1024),
@pCATEGORY int,
@pTYPE_VALUE int,
@pTYPE_NAME varchar(255),
@pDISPLAY_FORMAT varchar(32),
@pDATA float
AS
INSERT INTO STEP_NUMERICLIMIT1 ( ID,STEP_RESULT,PROP_PARENT,ORDER_NUMBER,NAME,PATH,CATEGORY,TYPE_VALUE,TYPE_NAME,DISPLAY_FORMAT,DATA)
VALUES (
@pID,
@pSTEP_RESULT,
@pPROP_PARENT,
@pORDER_NUMBER,
@pNAME,
@pPATH,
@pCATEGORY,
@pTYPE_VALUE,
@pTYPE_NAME,
@pDISPLAY_FORMAT,
@pDATA)
GO

CREATE PROCEDURE InsertNumericLimit
@pID uniqueidentifier,
@pPROP_RESULT uniqueidentifier,
@pCOMP_OPERATOR varchar(32),
@pHIGH_LIMIT float,
@pLOW_LIMIT float,
@pUNITS varchar(255),
@pSTATUS varchar(255)
AS
INSERT INTO STEP_NUMERICLIMIT2 ( ID,PROP_RESULT,COMP_OPERATOR,HIGH_LIMIT,LOW_LIMIT,UNITS,STATUS)
VALUES (
@pID,
@pPROP_RESULT,
@pCOMP_OPERATOR,
@pHIGH_LIMIT,
@pLOW_LIMIT,
@pUNITS,
@pSTATUS)
GO

CREATE PROCEDURE InsertPropResult
@pID uniqueidentifier,
@pSTEP_RESULT uniqueidentifier,
@pPROP_PARENT uniqueidentifier,
@pORDER_NUMBER int,
@pNAME varchar(255),
@pPATH varchar(255),
@pCATEGORY int,
@pTYPE_VALUE int,
@pTYPE_NAME varchar(255),
@pDISPLAY_FORMAT varchar(32),
@pDATA varchar(255)
AS
INSERT INTO PROP_MULTINUMERICLIMIT1 ( ID,STEP_RESULT,PROP_PARENT,ORDER_NUMBER,NAME,PATH,CATEGORY,TYPE_VALUE,TYPE_NAME,DISPLAY_FORMAT,DATA)
VALUES (
@pID,
@pSTEP_RESULT,
@pPROP_PARENT,
@pORDER_NUMBER,
@pNAME,
@pPATH,
@pCATEGORY,
@pTYPE_VALUE,
@pTYPE_NAME,
@pDISPLAY_FORMAT,
@pDATA)
GO

CREATE PROCEDURE InsertAnalogWaveform
@pID uniqueidentifier,
@pPROP_RESULT uniqueidentifier,
@pINITIAL_T datetime,
@pDELTA_T float,
@pINITIAL_X float,
@pDELTA_X float,
@pUPPER_BOUNDS varchar(32),
@pLOWER_BOUNDS varchar(32),
@pDATA_FORMAT varchar(32),
@pDATA image,
@pATTRIBUTES varchar(1024)
AS
INSERT INTO PROP_ANALOGWAVEFORM ( ID,PROP_RESULT,INITIAL_T,DELTA_T,INITIAL_X,DELTA_X,UPPER_BOUNDS,LOWER_BOUNDS,DATA_FORMAT,DATA,ATTRIBUTES)
VALUES (
@pID,
@pPROP_RESULT,
@pINITIAL_T,
@pDELTA_T,
@pINITIAL_X,
@pDELTA_X,
@pUPPER_BOUNDS,
@pLOWER_BOUNDS,
@pDATA_FORMAT,
@pDATA,
@pATTRIBUTES)
GO

CREATE PROCEDURE InsertDigitalWaveform
@pID uniqueidentifier,
@pPROP_RESULT uniqueidentifier,
@pINITIAL_T datetime,
@pDELTA_T float,
@pUPPER_BOUNDS varchar(32),
@pLOWER_BOUNDS varchar(32),
@pTRANSITIONS image,
@pDATA image,
@pATTRIBUTES varchar(1024)
AS
INSERT INTO PROP_DIGITALWAVEFORM ( ID,PROP_RESULT,INITIAL_T,DELTA_T,UPPER_BOUNDS,LOWER_BOUNDS,TRANSITIONS,DATA,ATTRIBUTES)
VALUES (
@pID,
@pPROP_RESULT,
@pINITIAL_T,
@pDELTA_T,
@pUPPER_BOUNDS,
@pLOWER_BOUNDS,
@pTRANSITIONS,
@pDATA,
@pATTRIBUTES)
GO

CREATE PROCEDURE InsertIviWave
@pID uniqueidentifier,
@pPROP_RESULT uniqueidentifier,
@pINITIAL_X float,
@pDELTA_X float,
@pUPPER_BOUNDS varchar(32),
@pLOWER_BOUNDS varchar(32),
@pDATA_FORMAT varchar(32),
@pDATA image,
@pATTRIBUTES varchar(1024)
AS
INSERT INTO PROP_IVIWAVE ( ID,PROP_RESULT,INITIAL_X,DELTA_X,UPPER_BOUNDS,LOWER_BOUNDS,DATA_FORMAT,DATA,ATTRIBUTES)
VALUES (
@pID,
@pPROP_RESULT,
@pINITIAL_X,
@pDELTA_X,
@pUPPER_BOUNDS,
@pLOWER_BOUNDS,
@pDATA_FORMAT,
@pDATA,
@pATTRIBUTES)
GO

CREATE PROCEDURE InsertPropBinary
@pID uniqueidentifier,
@pPROP_RESULT uniqueidentifier,
@pUPPER_BOUNDS varchar(32),
@pLOWER_BOUNDS varchar(32),
@pDATA_FORMAT varchar(32),
@pDATA image
AS
INSERT INTO PROP_BINARY ( ID,PROP_RESULT,UPPER_BOUNDS,LOWER_BOUNDS,DATA_FORMAT,DATA)
VALUES (
@pID,
@pPROP_RESULT,
@pUPPER_BOUNDS,
@pLOWER_BOUNDS,
@pDATA_FORMAT,
@pDATA)
GO

IF OBJECT_ID('dbo.UUT_RESULT_TEMP') IS NULL
CREATE TABLE UUT_RESULT_TEMP (
 ID bigint,
 STATION_ID nvarchar(255),
 BATCH_SERIAL_NUMBER nvarchar(255),
 TEST_SOCKET_INDEX	int,
 UUT_SERIAL_NUMBER nvarchar(255),
 USER_LOGIN_NAME	nvarchar(255),
 START_DATE_TIME datetime,
 EXECUTION_TIME float,
 UUT_STATUS nvarchar(255),
 UUT_ERROR_CODE	int,
 UUT_ERROR_MESSAGE	nvarchar(255),
 INTERFACE_JIG nvarchar(50),
 PRODUCT nvarchar(50)
)
GO

IF OBJECT_ID('dbo.STEP_RESULT_TEMP') IS NULL
CREATE TABLE STEP_RESULT_TEMP (
 ID bigint,
 UUT_RESULT bigint,
 STEP_PARENT int,
 ORDER_NUMBER int,
 STEP_NAME nvarchar(255),
 STEP_TYPE	nvarchar(255),
 STEP_GROUP	nvarchar(32),
 STEP_INDEX	int,
 STEP_ID	nvarchar(32),
 STATUS	nvarchar(255),
 REPORT_TEXT	nvarchar(255),
 ERROR_CODE	int,
 ERROR_MESSAGE	nvarchar(255),
 CAUSED_SEQFAIL	bit,
 MODULE_TIME	float,
 TOTAL_TIME	decimal(18,5),
 NUM_LOOPS	int,
 NUM_PASSED	int,
 NUM_FAILED	int,
 ENDING_LOOP_INDEX	int,
 LOOP_INDEX	int,
 INTERACTIVE_EXENUM	int,
 RESULT_TYPE nvarchar(255),
 DATA	float,
 HIGH_LIMIT float,
 LOW_LIMIT float,
 UNITS nvarchar(255)
)
GO

IF OBJECT_ID('dbo.STEP_SEQCALL_TEMP') IS NULL
CREATE TABLE STEP_SEQCALL_TEMP (
ID bigint,
STEP_RESULT	bigint,
SEQUENCE_NAME	nvarchar(255),
SEQUENCE_FILE_PATH	nvarchar(1024)
)
GO

IF OBJECT_ID('dbo.PROP_RESULT_TEMP') IS NULL
CREATE TABLE PROP_RESULT_TEMP (
ID bigint,
STEP_RESULT	bigint,
PROP_PARENT	int,
ORDER_NUMBER	int,
NAME	nvarchar(255),
PATH	nvarchar(1024),
CATEGORY	int,
TYPE_VALUE	int,
TYPE_NAME	nvarchar(255),
DISPLAY_FORMAT	nvarchar(32),
DATA	nvarchar(255)
)
GO

IF OBJECT_ID('dbo.PROP_NUMERICLIMIT_TEMP') IS NULL
CREATE TABLE PROP_NUMERICLIMIT_TEMP(
ID bigint,
PROP_RESULT bigint,
COMP_OPERATOR nvarchar(32),
HIGH_LIMIT float,
LOW_LIMIT float,
UNITS nvarchar(255),
STATUS nvarchar(255)
)
GO

-- Table to store list of Sources
CREATE TABLE SOURCE_LIST(
	ID [smallint],
	SERVER_NAME [varchar](128),
	DATABASE_NAME [varchar](128),
	TABLE_NAME [varchar](128),
	CONN_STRING [nvarchar](255)
)
GO

-- Local Table to store Results
CREATE TABLE Results(
	TABLE_NAME [varchar](128),
	CONN_STRING [nvarchar](255),
	RECORD_COUNT [int],
	ACTION_TIME [datetime]
)
GO


CREATE TABLE rstage.ETLExecutionLog
(
    ExecutionLogID        INT IDENTITY(1,1) PRIMARY KEY,
    PackageName           VARCHAR(200),
    SourceFileName        VARCHAR(500),
    SourceTable           VARCHAR(200),
    FileSizeKB            DECIMAL(18,2),
    RowsProcessed         INT,
    ExecutionStartTime    DATETIME,
    ExecutionEndTime      DATETIME,
    ExecutionStatus       VARCHAR(50),
    CreatedDate           DATETIME DEFAULT GETDATE()
);
ALTER TABLE rstage.ETLErrorLog
ADD
    SourceTable       VARCHAR(200),
    SourceKey         VARCHAR(200),
    ValidationType    VARCHAR(100);
GO
CREATE TABLE rstage.ETLErrorLog
(
    ErrorLogID         INT IDENTITY(1,1) PRIMARY KEY,
    PackageName        VARCHAR(200),
    TaskName           VARCHAR(200),
    ErrorMessage       VARCHAR(MAX),
    ErrorDescription   VARCHAR(MAX),
    ExecutionTime      DATETIME DEFAULT GETDATE()
);
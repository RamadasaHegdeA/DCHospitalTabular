/* =========================================================
   =========================================================
        CORE LOAD PROCEDURES
   =========================================================
   ========================================================= */
 
USE EIP;
GO
 
 
--***********************************************************
-- SP Name 		: [rcore].[PopulateDimDate]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Date Dimension
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
CREATE OR ALTER   PROCEDURE [rcore].[PopulateDimDate]
AS
BEGIN
BEGIN TRAN

    BEGIN TRY 
 
    SET NOCOUNT ON;
 
    DECLARE @StartDate DATE = '2020-01-01'; --Change the date range to add more data
    DECLARE @EndDate   DATE = '2035-12-31';
    
    ;WITH DateCTE AS
    (
        SELECT @StartDate AS FullDate
 
        UNION ALL
 
        SELECT DATEADD(DAY,1,FullDate)
        FROM DateCTE
        WHERE FullDate < @EndDate
    )
 
    INSERT INTO rcore.DimDate
    (
        DateKey,
        FullDate,
        DayNumber,
        MonthNumber,
        MonthName,
        QuarterNumber,
        YearNumber,
        WeekNumber
    )
 
    SELECT
        CAST(FORMAT(FullDate,'yyyyMMdd') AS INT),
        FullDate,
        DAY(FullDate),
        MONTH(FullDate),
        DATENAME(MONTH, FullDate),
        DATEPART(QUARTER, FullDate),
        YEAR(FullDate),
        DATEPART(WEEK, FullDate)
 
    FROM DateCTE
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM rcore.DimDate D
        WHERE D.FullDate = DateCTE.FullDate /*Block added to avoid truncate and load */
    )
 
    OPTION (MAXRECURSION 0);
COMMIT TRAN 
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN
  /*Future Scope - create log error and run details table and capture the execution details in the process*/
--RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END;
 
 

 
--***********************************************************
-- SP Name 		: [rcore].[PopulateDimPatient]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Patient Details
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
CREATE OR ALTER   PROCEDURE [rcore].[PopulateDimPatient]
AS
BEGIN
BEGIN TRAN

    BEGIN TRY 
 
    SET NOCOUNT ON;
 
 
    INSERT INTO rcore.DimPatient
    (
        PatientID,
        FullName,
        Gender,
        DOB,
        Age,
        City,
        State,
        Country,
        EffectiveStartDate,
        EffectiveEndDate,
        IsCurrent
    )
 
    SELECT
        S.PatientID,
        S.FullName,
        S.Gender,
        S.DOB,
        DATEDIFF(YEAR, S.DOB, GETDATE()),
        
        S.City,
        S.State,
        S.Country,
 
        GETDATE(),
        '9999-12-31',
        1
 
    FROM EIPStaging.rstage.PatientMaster S
 
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM rcore.DimPatient D
        WHERE D.PatientID = S.PatientID
        AND D.IsCurrent = 1
    );
COMMI TRAN 
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN
    --RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END; 
 

 
--***********************************************************
-- SP Name 		: [rcore].[PopulateDimPolicy]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Policy Details
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
CREATE OR ALTER   PROCEDURE [rcore].[PopulateDimPolicy]
AS
BEGIN
BEGIN TRAN

    BEGIN TRY 
 
    SET NOCOUNT ON;
 
    INSERT INTO rcore.DimPolicy
    (
        PolicyID,
        PolicyName,
        PolicyType,
        CoverageAmount,
        DeductibleAmount,
        CoPayPercent,
        EffectiveStartDate,
        EffectiveEndDate,
        IsCurrent
    )
 
    SELECT
        S.PolicyID,
        S.PolicyName,
        S.PolicyType,
        S.CoverageAmount,
        S.DeductibleAmount,
        S.CoPayPercent,
 
        S.EffectiveDate,
        '9999-12-31',
        1
 
    FROM EIPStaging.rstage.PolicyMaster S
 
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM rcore.DimPolicy D
        WHERE D.PolicyID = S.PolicyID
        AND D.IsCurrent = 1
    );
 
    COMMIT TRAN
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN

    /*Future Scope - create log error and run details table and capture the execution details in the process*/
    --RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END;
 
 


--***********************************************************
-- SP Name 		: [rcore].[[PopulateDimProvider]]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Provider Info
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
CREATE OR ALTER   PROCEDURE [rcore].[PopulateDimProvider]
AS
BEGIN
BEGIN TRAN

    BEGIN TRY 
        SET NOCOUNT ON;

 
    SET NOCOUNT ON;
    /* Following is the example choosen as SCD2 Implementation. There is currently only 1 table used to display as example */
    MERGE rcore.DimProvider AS TARGET
 
    USING
    (
        SELECT *
        FROM EIPStaging.rstage.ProviderMaster
    ) AS SOURCE
 
    ON TARGET.ProviderID = SOURCE.ProviderID
 
    WHEN MATCHED THEN
 
        UPDATE SET
            TARGET.ProviderName = SOURCE.ProviderName,
            TARGET.ProviderType = SOURCE.ProviderType,
            TARGET.City         = SOURCE.City,
            TARGET.State        = SOURCE.State,
            TARGET.Country      = SOURCE.Country
 
    WHEN NOT MATCHED THEN
 
        INSERT
        (
            ProviderID,
            ProviderName,
            ProviderType,
            City,
            State,
            Country
        )
 
        VALUES
        (
            SOURCE.ProviderID,
            SOURCE.ProviderName,
            SOURCE.ProviderType,
            SOURCE.City,
            SOURCE.State,
            SOURCE.Country
        );
 
    COMMIT TRAN
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN
--RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END; 
 

--***********************************************************
-- SP Name 		: [rcore].[PopulateDimDiagnosis]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Diagnosis Details
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
CREATE OR ALTER   PROCEDURE [rcore].[PopulateDimDiagnosis]
AS
BEGIN
BEGIN TRAN

    BEGIN TRY 
 
    SET NOCOUNT ON;
 
    INSERT INTO rcore.DimDiagnosis
    (
        DiagnosisCode,
        DiagnosisName,
        DiseaseCategory
    )
 
    SELECT DISTINCT
        DiagnosisCode,
        DiagnosisName,
        DiseaseCategory
 
    FROM EIPStaging.rstage.PatientMedicalIssue S
 
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM rcore.DimDiagnosis D
        WHERE D.DiagnosisCode = S.DiagnosisCode
    );
 
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN
    /*Future Scope - create log error and run details table and capture the execution details in the process*/
    --RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END; 
 
 
USE [EIP]
GO
/****** Object:  StoredProcedure [rcore].[PopulateFactClaim]    Script Date: 5/26/2026 12:04:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 




--***********************************************************
-- SP Name 		: [rcore].[PopulateFactClaim]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Load Claim Fact Table
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the Procedure

--***********************************************************
 
ALTER     PROCEDURE [rcore].[PopulateFactClaim]
AS
BEGIN
BEGIN TRAN

    DECLARE @ErrorlogID INT;
    SELECT ErrorLogID =  @ErrorlogID FROM EIPstaging.rstage.ETLErrorLog;
    
    --Data Quality Check--
    BEGIN
        --Patient Check
        INSERT INTO EIPstaging.rstage.ETLErrorLog

        (

            PackageName,

            TaskName,

            ErrorMessage,

            ErrorDescription,

            SourceTable,

            SourceKey,

            ValidationType

        )

        SELECT

            'PopulateFactClaim',

            'Patient Validation',

            'Missing Patient Dimension',

            'PatientID not found in DimPatient',

            'Staging.stg_PatientClaims',

            CAST(pc.PatientID AS VARCHAR(50)),

            'Missing Patient'

        FROM EIPstaging.rstage.PatientClaims pc

        LEFT JOIN rCore.DimPatient dp

            ON pc.PatientID = dp.PatientID

            AND dp.IsCurrent = 1

        WHERE dp.PatientID IS NULL;
 
        --Policy check
        INSERT INTO EIPstaging.rstage.ETLErrorLog

        (

            PackageName,

            TaskName,

            ErrorMessage,

            ErrorDescription,

            SourceTable,

            SourceKey,

            ValidationType

        )

        SELECT

            'PopulateFactClaim',

            'Policy Validation',

            'Missing Policy Dimension',

            'PolicyID not found in DimPolicy',

            'Staging.stg_PatientClaims',

            CAST(pc.PolicyID AS VARCHAR(50)),

            'Missing Policy'

        FROM EIPstaging.rstage.PatientClaims pc

        LEFT JOIN rCore.DimPolicy dp

            ON pc.PolicyID = dp.PolicyID

            AND dp.IsCurrent = 1

        WHERE dp.PolicyID IS NULL;
 
        --Provider check
        INSERT INTO EIPstaging.rstage.ETLErrorLog

        (

            PackageName,

            TaskName,

            ErrorMessage,

            ErrorDescription,

            SourceTable,

            SourceKey,

            ValidationType

        )

        SELECT

            'PopulateFactClaim',

            'Provider Validation',

            'Missing Provider Dimension',

            'ProviderID not found in DimProvider',

            'Staging.stg_PatientClaims',

            CAST(pc.ProviderID AS VARCHAR(50)),

            'Missing Provider'

        FROM EIPstaging.rstage.PatientClaims pc

        LEFT JOIN rCore.DimProvider dp

            ON pc.ProviderID = dp.ProviderID

        WHERE dp.ProviderID IS NULL;
 
        --Diagnisys check
        INSERT INTO EIPstaging.rstage.ETLErrorLog

        (

            PackageName,

            TaskName,

            ErrorMessage,

            ErrorDescription,

            SourceTable,

            SourceKey,

            ValidationType

        )

        SELECT

            'PopulateFactClaim',

            'Diagnosis Validation',

            'Missing Diagnosis Dimension',

            'Diagnosis not found in DimDiagnosis',

            'Staging.stg_PatientClaims',

            CAST(pc.MedicalIssueID AS VARCHAR(50)),

            'Missing Diagnosis'

        FROM EIPstaging.rstage.PatientClaims pc

        LEFT JOIN EIPstaging.rstage.PatientMedicalIssue mi

            ON pc.MedicalIssueID = mi.MedicalIssueID

        LEFT JOIN rCore.DimDiagnosis dd

            ON mi.DiagnosisCode = dd.DiagnosisCode

        WHERE dd.DiagnosisCode IS NULL;
 
        --IF 

        --(

        --    SELECT MAX(ErrorLogID) ErrorLogID

        --    FROM EIPstaging.rstage.ETLErrorLog

        --    WHERE PackageName = 'PopulateFactClaim'

        --    AND CAST(ExecutionTime AS DATE) = CAST(GETDATE() AS DATE)

        --) <> @ErrorlogID

        --BEGIN

        --    RAISERROR(

        --        'Data Quality Validation Failed',

        --        16,

        --        1

        --    );

        --    RETURN;

        --END;
 

    END;
    BEGIN TRY 
        SET NOCOUNT ON;
        /*Updates are not considered after claim submissions, Fact depicts the Claim level data*/
        --INSERT INTO rcore.FactClaim
        --(
        --    ClaimID,
 
        --    PatientKey,
        --    PolicyKey,
        --    ProviderKey,
        --    DiagnosisKey,
 
        --    ClaimDateKey,
        --    AdmissionDateKey,
        --    DischargeDateKey,
 
        --    ClaimedAmount,
        --    ApprovedAmount,
        --    RejectedAmount,
        --    OutOfPocketAmount,
 
        --    LengthOfStay,
 
        --    ClaimStatus,
        --    ClaimCount
        --)
 
        --SELECT
        --    C.ClaimID,
 
        --    DP.PatientKey,
        --    DPO.PolicyKey,
        --    DPR.ProviderKey,
        --    DD.DiagnosisKey,
 
        --    CAST(FORMAT(C.ClaimDate,'yyyyMMdd') AS INT),
        --    CAST(FORMAT(C.AdmissionDate,'yyyyMMdd') AS INT),
        --    CAST(FORMAT(C.DischargeDate,'yyyyMMdd') AS INT),
 
        --    C.ClaimedAmount,
        --    C.ApprovedAmount,
        --    C.RejectedAmount,
        --    C.OutOfPocketAmount,
 
        --    DATEDIFF(DAY, C.AdmissionDate, C.DischargeDate),
 
        --    C.ClaimStatus,
        --    1               --Single claim per record
 
        --FROM EIPStaging.rstage.PatientClaims C
 
        --INNER JOIN rcore.DimPatient DP
        --    ON C.PatientID = DP.PatientID
        --    AND DP.IsCurrent = 1
 
        --INNER JOIN rcore.DimPolicy DPO
        --    ON C.PolicyID = DPO.PolicyID
        --    AND DPO.IsCurrent = 1
 
        --INNER JOIN rcore.DimProvider DPR
        --    ON C.ProviderID = DPR.ProviderID
 
        --INNER JOIN EIPStaging.rstage.PatientMedicalIssue PMI
        --    ON C.MedicalIssueID = PMI.MedicalIssueID
 
        --INNER JOIN rcore.DimDiagnosis DD
        --    ON PMI.DiagnosisCode = DD.DiagnosisCode
 
        --WHERE NOT EXISTS
        --(
        --    SELECT 1
        --    FROM rcore.FactClaim F
        --    WHERE F.ClaimID = C.ClaimID
        --);
    ;WITH FactSource AS
    (
        SELECT
            PC.ClaimID,
            ISNULL(DP.PatientKey,-1)       AS PatientKey,
            ISNULL(POL.PolicyKey,-1)       AS PolicyKey,
            ISNULL(PR.ProviderKey,-1)      AS ProviderKey,
            ISNULL(DD.DiagnosisKey,-1)     AS DiagnosisKey,
            CD.DateKey                     AS ClaimDateKey,
            AD.DateKey                     AS AdmissionDateKey,
            DDT.DateKey                    AS DischargeDateKey,
            PC.ClaimedAmount,
            PC.ApprovedAmount,
            PC.RejectedAmount,
            PC.OutOfPocketAmount,
            DATEDIFF
            (
                DAY,
                PC.AdmissionDate,
                PC.DischargeDate
            ) AS LengthOfStay,
            PC.ClaimStatus
        FROM EIPStaging.rstage.PatientClaims PC
            LEFT JOIN rCore.DimPatient DP
                ON  PC.PatientID = DP.PatientID
                AND DP.IsCurrent = 1
            LEFT JOIN rCore.DimPolicy POL
                ON  PC.PolicyID = POL.PolicyID
                AND POL.IsCurrent = 1
            LEFT JOIN rCore.DimProvider PR
                ON PC.ProviderID = PR.ProviderID
                AND PR.IsCurrent = 1
            LEFT JOIN EIPStaging.rstage.PatientMedicalIssue PMI
                ON PC.MedicalIssueID = PMI.MedicalIssueID
            LEFT JOIN rCore.DimDiagnosis DD
                ON PMI.DiagnosisCode = DD.DiagnosisCode
            INNER JOIN rCore.DimDate CD
                ON CD.FullDate = PC.ClaimDate
            INNER JOIN rCore.DimDate AD
                ON AD.FullDate = PC.AdmissionDate
            INNER JOIN rCore.DimDate DDT
                ON DDT.FullDate = PC.DischargeDate
            WHERE CAST(PC.ClaimDate AS DATE) > CAST(GETDATE()-(365*3) AS DATE)
    )

    /* =========================================================
       MERGE FACT CLAIM
       ========================================================= */
    MERGE rCore.FactClaim AS TARGET
    USING FactSource AS SOURCE
    ON TARGET.ClaimID = SOURCE.ClaimID

    /* =========================================================
       UPDATE EXISTING CLAIMS
       ========================================================= */
    WHEN MATCHED
    AND
    (
           ISNULL(TARGET.PatientKey,-1)
    <> ISNULL(SOURCE.PatientKey,-1)
        OR ISNULL(TARGET.PolicyKey,-1)
    <> ISNULL(SOURCE.PolicyKey,-1)
        OR ISNULL(TARGET.ProviderKey,-1)
    <> ISNULL(SOURCE.ProviderKey,-1)
        OR ISNULL(TARGET.DiagnosisKey,-1)
    <> ISNULL(SOURCE.DiagnosisKey,-1)
        OR ISNULL(TARGET.ClaimDateKey,-1)
    <> ISNULL(SOURCE.ClaimDateKey,-1)
        OR ISNULL(TARGET.AdmissionDateKey,-1)
    <> ISNULL(SOURCE.AdmissionDateKey,-1)
        OR ISNULL(TARGET.DischargeDateKey,-1)
    <> ISNULL(SOURCE.DischargeDateKey,-1)
        OR ISNULL(TARGET.ClaimedAmount,0)
    <> ISNULL(SOURCE.ClaimedAmount,0)
        OR ISNULL(TARGET.ApprovedAmount,0)
    <> ISNULL(SOURCE.ApprovedAmount,0)
        OR ISNULL(TARGET.RejectedAmount,0)
    <> ISNULL(SOURCE.RejectedAmount,0)
        OR ISNULL(TARGET.OutOfPocketAmount,0)
    <> ISNULL(SOURCE.OutOfPocketAmount,0)
        OR ISNULL(TARGET.LengthOfStay,0)
    <> ISNULL(SOURCE.LengthOfStay,0)
        OR ISNULL(TARGET.ClaimStatus,'')
    <> ISNULL(SOURCE.ClaimStatus,'')
    )
    THEN
    UPDATE SET
        TARGET.PatientKey        = SOURCE.PatientKey,
        TARGET.PolicyKey         = SOURCE.PolicyKey,
        TARGET.ProviderKey       = SOURCE.ProviderKey,
        TARGET.DiagnosisKey      = SOURCE.DiagnosisKey,
        TARGET.ClaimDateKey      = SOURCE.ClaimDateKey,
        TARGET.AdmissionDateKey  = SOURCE.AdmissionDateKey,
        TARGET.DischargeDateKey  = SOURCE.DischargeDateKey,
        TARGET.ClaimedAmount     = SOURCE.ClaimedAmount,
        TARGET.ApprovedAmount    = SOURCE.ApprovedAmount,
        TARGET.RejectedAmount    = SOURCE.RejectedAmount,
        TARGET.OutOfPocketAmount = SOURCE.OutOfPocketAmount,
        TARGET.LengthOfStay      = SOURCE.LengthOfStay,
        TARGET.ClaimStatus       = SOURCE.ClaimStatus,
        TARGET.ModifiedDate      = GETDATE()--,
        --TARGET.BatchID           = @BatchID

    /* =========================================================
       INSERT NEW CLAIMS
       ========================================================= */
    WHEN NOT MATCHED BY TARGET
    THEN
    INSERT
    (
        ClaimID,
        PatientKey,
        PolicyKey,
        ProviderKey,
        DiagnosisKey,
        ClaimDateKey,
        AdmissionDateKey,
        DischargeDateKey,
        ClaimedAmount,
        ApprovedAmount,
        RejectedAmount,
        OutOfPocketAmount,
        LengthOfStay,
        ClaimStatus,
        ClaimCount,
        CreatedDate--,
       -- BatchID
    )
    VALUES
    (
        SOURCE.ClaimID,
        SOURCE.PatientKey,
        SOURCE.PolicyKey,
        SOURCE.ProviderKey,
        SOURCE.DiagnosisKey,
        SOURCE.ClaimDateKey,
        SOURCE.AdmissionDateKey,
        SOURCE.DischargeDateKey,
        SOURCE.ClaimedAmount,
        SOURCE.ApprovedAmount,
        SOURCE.RejectedAmount,
        SOURCE.OutOfPocketAmount,
        SOURCE.LengthOfStay,
        SOURCE.ClaimStatus,
        1,
        GETDATE()--,
        --@BatchID
    );

    COMMIT TRAN
END TRY
BEGIN CATCH
IF @@TranCount <> 0
	ROLLBACK TRAN
      /*Future Scope - create log error and run details table and capture the execution details in the process*/
    --RAISEERROR ('Error Populating the Fact', 16, 1);
	--IF @@TranCount <> 0
	--	ROLLBACK TRAN
	--EXEC [EndeavorHRDMStaging].[Stage].[sp_AuditLoad] @RunLogID=@RunLogID, @SubAreaName=@SubAreaName, @Status=@StatusFail, @RowsExtracted=@RowsExtracted , @RowsLoaded=@RowsLoaded, @RowsRejected=@RowsRejected, @LoadStartDate=@LoadStartDate, --@LoadEndDate=GETUTCDATE(),
	--@SubAreaType= @SubAreaType , @TaskName=@TaskName
	--INSERT INTO [EndeavorHRDMStaging].Stage.ErrorLog (RunLogID,PackageName,TaskName,ErrorCode,ErrorDescription,FailedDate)
	--		            VALUES(@RunLogID,@PackageName,@TaskName,ERROR_NUMBER(),ERROR_MESSAGE(),GETUTCDATE());
	THROW;
END CATCH
END;

GO
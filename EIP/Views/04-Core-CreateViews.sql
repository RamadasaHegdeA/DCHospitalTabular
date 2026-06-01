/* =========================================================
   =========================================================
                    DIMENSION VIEWS
   =========================================================
   ========================================================= */
   USE EIP;
/* =========================================================
   VW DIM DATE
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_DimDate
AS
SELECT
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber,
    WeekNumber
FROM rcore.DimDate;
GO

/* =========================================================
   VW DIM PATIENT
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_DimPatient
AS
SELECT
    PatientKey,
    PatientID,
    FullName,
    Gender,
    DOB,
    Age,
    City,
    State,
    Country
FROM rcore.DimPatient
WHERE IsCurrent = 1;
GO

/* =========================================================
   VW DIM POLICY
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_DimPolicy
AS
SELECT
    PolicyKey,
    PolicyID,
    PolicyName,
    PolicyType,
    CoverageAmount,
    DeductibleAmount,
    CoPayPercent
FROM rcore.DimPolicy
WHERE IsCurrent = 1;
GO

/* =========================================================
   VW DIM PROVIDER
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_DimProvider
AS
SELECT
    ProviderKey,
    ProviderID,
    ProviderName,
    ProviderType,
    City,
    State,
    Country
FROM rcore.DimProvider;
GO

/* =========================================================
   VW DIM DIAGNOSIS
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_DimDiagnosis
AS
SELECT
    DiagnosisKey,
    DiagnosisCode,
    DiagnosisName,
    DiseaseCategory
FROM rcore.DimDiagnosis;
GO


/* =========================================================
   =========================================================
                    FACT VIEW
   =========================================================
   ========================================================= */

/* =========================================================
   VW FACT CLAIM
   ========================================================= */
CREATE OR ALTER VIEW rcore.vw_FactClaim
AS
SELECT
    ClaimFactKey,
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
    ClaimCount
FROM rcore.FactClaim;
GO
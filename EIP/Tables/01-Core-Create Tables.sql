
/* =========================================================
   =========================================================
                    rcore. DIMENSIONS
   =========================================================
   ========================================================= */
USE EIP 
 
/* =========================================================
   DIM DATE
   ========================================================= */
 
CREATE TABLE rcore..DimDate
(
    DateKey                INT PRIMARY KEY,
    FullDate               DATE,
    DayNumber              INT,
    MonthNumber            INT,
    MonthName              VARCHAR(20),
    QuarterNumber          INT,
    YearNumber             INT,
    WeekNumber             INT
);
GO
 
 
/* =========================================================
   DIM PATIENT (SCD TYPE 2)
   ========================================================= */
 
CREATE TABLE rcore..DimPatient
(
    PatientKey             INT IDENTITY(1,1) PRIMARY KEY,
    PatientID              INT,
 
    FullName               VARCHAR(200),
    Gender                 VARCHAR(20),
    DOB                    DATE,
    Age                    INT,
 
    City                   VARCHAR(100),
    State                  VARCHAR(100),
    Country                VARCHAR(100),
 
    EffectiveStartDate     DATE,
    EffectiveEndDate       DATE,
    IsCurrent              BIT
);
GO
 
 
/* =========================================================
   DIM POLICY (SCD TYPE 2)
   ========================================================= */
 
CREATE TABLE rcore..DimPolicy
(
    PolicyKey              INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID               INT,
 
    PolicyName             VARCHAR(200),
    PolicyType             VARCHAR(100),
 
    CoverageAmount         DECIMAL(18,2),
    DeductibleAmount       DECIMAL(18,2),
    CoPayPercent           DECIMAL(5,2),
 
    EffectiveStartDate     DATE,
    EffectiveEndDate       DATE,
    IsCurrent              BIT
);
GO
 
 
/* =========================================================
   DIM PROVIDER (SCD TYPE 1)
   ========================================================= */
 
CREATE TABLE rcore..DimProvider
(
    ProviderKey            INT IDENTITY(1,1) PRIMARY KEY,
    ProviderID             INT,
 
    ProviderName           VARCHAR(200),
    ProviderType           VARCHAR(100),
 
    City                   VARCHAR(100),
    State                  VARCHAR(100),
    Country                VARCHAR(100)
);
GO
 
 
/* =========================================================
   DIM DIAGNOSIS
   ========================================================= */
 
CREATE TABLE rcore..DimDiagnosis
(
    DiagnosisKey           INT IDENTITY(1,1) PRIMARY KEY,
 
    DiagnosisCode          VARCHAR(50),
    DiagnosisName          VARCHAR(200),
    DiseaseCategory        VARCHAR(100)
);
GO
 
 
/* =========================================================
   =========================================================
                    rcore. FACT TABLE
   =========================================================
   ========================================================= */
 
 
/* =========================================================
   FACT CLAIM
   ========================================================= */
 
CREATE TABLE rcore..FactClaim
(
    ClaimFactKey           BIGINT IDENTITY(1,1) PRIMARY KEY,
 
    ClaimID                INT,
 
    PatientKey             INT,
    PolicyKey              INT,
    ProviderKey            INT,
    DiagnosisKey           INT,
 
    ClaimDateKey           INT,
    AdmissionDateKey       INT,
    DischargeDateKey       INT,
 
    ClaimedAmount          DECIMAL(18,2),
    ApprovedAmount         DECIMAL(18,2),
    RejectedAmount         DECIMAL(18,2),
    OutOfPocketAmount      DECIMAL(18,2),
 
    LengthOfStay           INT,
 
    ClaimStatus            VARCHAR(50),
 
    ClaimCount             INT DEFAULT 1
);
GO
 
 
/* =========================================================
   =========================================================
                    FOREIGN KEYS
   =========================================================
   ========================================================= */
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_DimPatient
FOREIGN KEY (PatientKey)
REFERENCES rcore..DimPatient(PatientKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_DimPolicy
FOREIGN KEY (PolicyKey)
REFERENCES rcore..DimPolicy(PolicyKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_DimProvider
FOREIGN KEY (ProviderKey)
REFERENCES rcore..DimProvider(ProviderKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_DimDiagnosis
FOREIGN KEY (DiagnosisKey)
REFERENCES rcore..DimDiagnosis(DiagnosisKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_ClaimDate
FOREIGN KEY (ClaimDateKey)
REFERENCES rcore..DimDate(DateKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_AdmissionDate
FOREIGN KEY (AdmissionDateKey)
REFERENCES rcore..DimDate(DateKey);
GO
 
 
ALTER TABLE rcore..FactClaim
ADD CONSTRAINT FK_FactClaim_DischargeDate
FOREIGN KEY (DischargeDateKey)
REFERENCES rcore..DimDate(DateKey);
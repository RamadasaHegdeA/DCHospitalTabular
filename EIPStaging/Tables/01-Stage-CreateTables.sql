/* =========================================================
   =========================================================
        HOSPITAL INSURANCE CLAIMS DATAMART
                STAGING + rcore. MODEL
   =========================================================
   ========================================================= */

 
 
/* =========================================================
   =========================================================
                    STAGING TABLES
   =========================================================
   ========================================================= */
 
USE EIPStaging 
/* =========================================================
   STG PATIENT MASTER
   ========================================================= */
 
CREATE TABLE rstage.PatientMaster
(
    PatientID              INT,
    FullName               VARCHAR(200),
    Gender                 VARCHAR(20),
    DOB                    DATE,
    City                   VARCHAR(100),
    State                  VARCHAR(100),
    Country                VARCHAR(100),
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
/* =========================================================
   STG PATIENT MEDICAL ISSUE
   ========================================================= */
 
CREATE TABLE rstage.PatientMedicalIssue
(
    MedicalIssueID         INT,
    PatientID              INT,
    DiagnosisCode          VARCHAR(50),
    DiagnosisName          VARCHAR(200),
    DiseaseCategory        VARCHAR(100),
    AdmissionDate          DATE,
    DischargeDate          DATE,
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
/* =========================================================
   STG POLICY MASTER
   ========================================================= */
 
CREATE TABLE rstage.PolicyMaster
(
    PolicyID               INT,
    PolicyName             VARCHAR(200),
    PolicyType             VARCHAR(100),
    CoverageAmount         DECIMAL(18,2),
    DeductibleAmount       DECIMAL(18,2),
    CoPayPercent           DECIMAL(5,2),
    EffectiveDate          DATE,
    ExpiryDate             DATE,
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
/* =========================================================
   STG PATIENT ENROLLMENT
   ========================================================= */
 
CREATE TABLE rstage.PatientEnrollment
(
    EnrollmentID           INT,
    PatientID              INT,
    PolicyID               INT,
    EnrollmentDate         DATE,
    EnrollmentStatus       VARCHAR(50),
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
/* =========================================================
   STG PROVIDER MASTER
   ========================================================= */
 
CREATE TABLE rstage.ProviderMaster
(
    ProviderID             INT,
    ProviderName           VARCHAR(200),
    ProviderType           VARCHAR(100),
    City                   VARCHAR(100),
    State                  VARCHAR(100),
    Country                VARCHAR(100),
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
/* =========================================================
   STG PATIENT CLAIMS
   ========================================================= */
 
CREATE TABLE rstage.PatientClaims
(
    ClaimID                INT,
    PatientID              INT,
    PolicyID               INT,
    ProviderID             INT,
    MedicalIssueID         INT,
 
    ClaimDate              DATE,
    AdmissionDate          DATE,
    DischargeDate          DATE,
 
    ClaimedAmount          DECIMAL(18,2),
    ApprovedAmount         DECIMAL(18,2),
    RejectedAmount         DECIMAL(18,2),
    OutOfPocketAmount      DECIMAL(18,2),
 
    ClaimStatus            VARCHAR(50),
 
    CreatedDate            DATETIME DEFAULT GETDATE()
);
GO
 
 
GO
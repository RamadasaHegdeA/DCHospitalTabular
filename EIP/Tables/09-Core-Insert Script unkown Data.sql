SET IDENTITY_INSERT rCore.DimPatient ON;

INSERT INTO rCore.DimPatient

(

    PatientKey,

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

    -1,

    -1,

    'Unknown Patient',

    'Unknown',

    '1900-01-01',

    0,

    'Unknown',

    'Unknown',

    'Unknown',

    '1900-01-01',

    '9999-12-31',

    1

WHERE NOT EXISTS

(

    SELECT 1

    FROM rCore.DimPatient

    WHERE PatientKey = -1

);

SET IDENTITY_INSERT rCore.DimPatient OFF;

GO
 
SET IDENTITY_INSERT rCore.DimPolicy ON;

INSERT INTO rCore.DimPolicy

(

    PolicyKey,

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

    -1,

    -1,

    'Unknown Policy',

    'Unknown',

    0,

    0,

    0,

    '1900-01-01',

    '9999-12-31',

    1

WHERE NOT EXISTS

(

    SELECT 1

    FROM rCore.DimPolicy

    WHERE PolicyKey = -1

);

SET IDENTITY_INSERT rCore.DimPolicy OFF;

GO
 
SET IDENTITY_INSERT rCore.DimProvider ON;

INSERT INTO rCore.DimProvider

(

    ProviderKey,

    ProviderID,

    ProviderName,

    ProviderType,

    City,

    State,

    Country

)

SELECT

    -1,

    -1,

    'Unknown Provider',

    'Unknown',

    'Unknown',

    'Unknown',

    'Unknown'

WHERE NOT EXISTS

(

    SELECT 1

    FROM rCore.DimProvider

    WHERE ProviderKey = -1

);

SET IDENTITY_INSERT rCore.DimProvider OFF;

GO
 
SET IDENTITY_INSERT rCore.DimDiagnosis ON;

INSERT INTO rCore.DimDiagnosis

(

    DiagnosisKey,

    DiagnosisCode,

    DiagnosisName,

    DiseaseCategory

)

SELECT

    -1,

    'UNKNOWN',

    'Unknown Diagnosis',

    'Unknown'

WHERE NOT EXISTS

(

    SELECT 1

    FROM rCore.DimDiagnosis

    WHERE DiagnosisKey = -1

);

SET IDENTITY_INSERT rCore.DimDiagnosis OFF;

GO
 
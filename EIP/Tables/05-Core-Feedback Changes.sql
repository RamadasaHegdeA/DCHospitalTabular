/* Feedback Recieved to check if the SCD2 is working on any of the scenario */
--Modified the table Provider to support SCD type 2
ALTER TABLE rCore.DimProvider
ADD
    EffectiveStartDate DATE,
    EffectiveEndDate DATE,
    IsCurrent BIT;

UPDATE  rCore.DimProvider
SET EffectiveStartDate =  CAST(GETDATE()-10 AS DATE),
    IsCurrent = 1


ALTER TABLE rCore.FactClaim
ADD
    CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate    DATETIME NULL;
GO

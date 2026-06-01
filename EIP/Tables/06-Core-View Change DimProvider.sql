USE [EIP]
GO

/****** Object:  View [rcore].[vw_DimProvider]    Script Date: 5/31/2026 10:00:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--***********************************************************
-- View Name 		: [rcore].[vw_DimProvider]
-- Date         : 25-May-2026
-- User         : Ramadasa Hegde A(COPR\hedg9004)
-- Description  : Provider view data
-- Used In		: SSIS package
--***********************************************************
--**********************Change Tracking**********************
-- Ticket  	    User    			    Date         Change 
-- NA			COPR\hedg9004			25-May-2026  Created the view
-- DMD-Feadback COPR\hedg9004           29-May-2026  Modified the code to support SCD Type 2 on Provider Dimension

--***********************************************************
ALTER   VIEW [rcore].[vw_DimProvider]
AS
SELECT
    ProviderKey,
    ProviderID,
    ProviderName,
    ProviderType,
    City,
    State,
    Country
FROM rcore.DimProvider
WHERE IsCurrent = 1;
GO



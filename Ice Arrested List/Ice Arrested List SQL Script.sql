SELECT * FROM ice_arrested_list;
CREATE TABLE ice_arrested_list_editable AS SELECT * FROM ice_arrested_list;
SELECT * FROM ice_arrested_list_editable;

/* begin cleaning duplicates */
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Apprehension Date`, `Apprehension State`, `Apprehension County`, `Apprehension AOR`, `Final Program`, `Final Program Group`, `Apprehension Method`, `Apprehension Criminality`, `Case Status`, `Case Category`, `Departed Date`, `Departure Country`, `Final Order Yes No`, `Final Order Date`, `Birth Date`, `Birth Year`, `Citizenship Country`, `Gender`, `Apprehension Site Landmark`, `Alien File Number`, `EID Case ID`, `EID Subject ID`, `Unique Identifier`) AS row_num
FROM ice_arrested_list_editable
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `ice_arrested_list_editable_2` (
  `Apprehension Date` text,
  `Apprehension State` text,
  `Apprehension County` text,
  `Apprehension AOR` text,
  `Final Program` text,
  `Final Program Group` text,
  `Apprehension Method` text,
  `Apprehension Criminality` text,
  `Case Status` text,
  `Case Category` text,
  `Departed Date` text,
  `Departure Country` text,
  `Final Order Yes No` text,
  `Final Order Date` text,
  `Birth Date` text,
  `Birth Year` int DEFAULT NULL,
  `Citizenship Country` text,
  `Gender` text,
  `Apprehension Site Landmark` text,
  `Alien File Number` text,
  `EID Case ID` text,
  `EID Subject ID` text,
  `Unique Identifier` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO ice_arrested_list_editable_2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Apprehension Date`, `Apprehension State`, `Apprehension County`, `Apprehension AOR`, `Final Program`, `Final Program Group`, `Apprehension Method`, `Apprehension Criminality`, `Case Status`, `Case Category`, `Departed Date`, `Departure Country`, `Final Order Yes No`, `Final Order Date`, `Birth Date`, `Birth Year`, `Citizenship Country`, `Gender`, `Apprehension Site Landmark`, `Alien File Number`, `EID Case ID`, `EID Subject ID`, `Unique Identifier`) AS row_num
FROM ice_arrested_list_editable;

DELETE
FROM ice_arrested_list_editable_2
WHERE row_num > 1;

SELECT *
FROM ice_arrested_list_editable_2
WHERE row_num > 1;

/* cleaning done */

/* data standardisation */

SELECT * FROM ice_arrested_list_editable_2;

SELECT DISTINCT `Apprehension Date`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT `Apprehension Date`,
STR_TO_DATE(`Apprehension Date`, '%m/%d/%Y')
FROM ice_arrested_list_editable_2;

UPDATE ice_arrested_list_editable_2
SET `Apprehension Date` = STR_TO_DATE(`Apprehension Date`, '%m/%d/%Y');

SELECT DISTINCT `Apprehension State`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Apprehension County`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Apprehension AOR`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Apprehension AOR` = REPLACE(`Apprehension AOR`, 'Area of Responsibility', '')
WHERE `Apprehension AOR` LIKE '%Area of Responsibility%';

UPDATE ice_arrested_list_editable_2
SET `Apprehension AOR` = TRIM(`Apprehension AOR`);

SELECT DISTINCT `Final Program`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Final Program` = '287G Task Force'
WHERE `Final Program` LIKE '287g Task Force';

SELECT DISTINCT `Final Program Group`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Apprehension Method`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Apprehension Method` = '287G Program'
WHERE `Apprehension Method` LIKE '287(g) Program';

UPDATE ice_arrested_list_editable_2
SET `Apprehension Method` = 'Other Efforts'
WHERE `Apprehension Method` LIKE 'Other efforts';

SELECT DISTINCT `Apprehension Criminality`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Apprehension Criminality` = 'Convicted Criminal'
WHERE `Apprehension Criminality` LIKE '1 Convicted Criminal';

UPDATE ice_arrested_list_editable_2
SET `Apprehension Criminality` = 'Pending Criminal Charges'
WHERE `Apprehension Criminality` LIKE '2 Pending Criminal Charges';

UPDATE ice_arrested_list_editable_2
SET `Apprehension Criminality` = 'Other Immigration Violator'
WHERE `Apprehension Criminality` LIKE '3 Other Immigration Violator';

SELECT DISTINCT `Case Status`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Case Status` = 'Active'
WHERE `Case Status` LIKE 'ACTIVE';

UPDATE ice_arrested_list_editable_2
SET `Case Status` = CASE
    WHEN `Case Status` = '0-Withdrawal Permitted - I-275 Issued' THEN 'Withdrawal Permitted - I-275 Issued'
    WHEN `Case Status` = '3-Voluntary Departure Confirmed' THEN 'Voluntary Departure Confirmed'
    WHEN `Case Status` = '5-Title 50 Expulsion' THEN 'Title 50 Expulsion'
    WHEN `Case Status` = '6-Deported/Removed - Deportability' THEN 'Deported/Removed - Deportability'
    WHEN `Case Status` = '7-Died' THEN 'Died'
    WHEN `Case Status` = '8-Excluded/Removed - Inadmissibility' THEN 'Excluded/Removed - Inadmissibility'
    WHEN `Case Status` = '9-VR Witnessed' THEN 'VR Witnessed'
    WHEN `Case Status` = 'A-Proceedings Terminated' THEN 'Proceedings Terminated'
    WHEN `Case Status` = 'B-Relief Granted' THEN 'Relief Granted'
    WHEN `Case Status` = 'E-Charging Document Canceled by ICE' THEN 'Charging Document Canceled by ICE'
    WHEN `Case Status` = 'L-Legalization - Permanent Residence Granted' THEN 'Legalization - Permanent Residence Granted'
    WHEN `Case Status` = 'Z-SAW - Permanent Residence Granted' THEN 'SAW - Permanent Residence Granted'
    ELSE `Case Status`
END
WHERE `Case Status` IN ('0-Withdrawal Permitted - I-275 Issued', '3-Voluntary Departure Confirmed', '5-Title 50 Expulsion', '6-Deported/Removed - Deportability', '7-Died'
, '8-Excluded/Removed - Inadmissibility', '9-VR Witnessed', 'A-Proceedings Terminated', 'B-Relief Granted', 'E-Charging Document Canceled by ICE'
, 'L-Legalization - Permanent Residence Granted', 'Z-SAW - Permanent Residence Granted');

SELECT DISTINCT `Case Category`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Case Category` = CASE
    WHEN `Case Category` = '[10] Visa Waiver Deportation / Removal' THEN 'Visa Waiver Deportation / Removal'
    WHEN `Case Category` = '[11] Administrative Deportation / Removal' THEN 'Administrative Deportation / Removal'
    WHEN `Case Category` = '[12] Judicial Deportation / Removal' THEN 'Judicial Deportation / Removal'
    WHEN `Case Category` = '[13] Section 250 Removal' THEN 'Section 250 Removal'
    WHEN `Case Category` = '[14] Crewmen, Stowaways, S-Visa Holders, 235(c) Cases' THEN 'Crewmen, Stowaways, S-Visa Holders, 235(c) Cases'
    WHEN `Case Category` = '[15] Terrorist Court Case (Title 5)' THEN 'Terrorist Court Case (Title 5)'
    WHEN `Case Category` = '[16] Reinstated Final Order' THEN 'Reinstated Final Order'
    WHEN `Case Category` = '[1A] Voluntary Departure - Un-Expired and Un-Extended Departure Period' THEN 'Voluntary Departure - Un-Expired and Un-Extended Departure Period'
    WHEN `Case Category` = '[1B] Voluntary Departure - Extended Departure Period' THEN 'Voluntary Departure - Extended Departure Period'
    WHEN `Case Category` = '[2A] Deportable - Under Adjudication by IJ' THEN 'Deportable - Under Adjudication by IJ'
    WHEN `Case Category` = '[2B] Deportable - Under Adjudication by BIA' THEN 'Deportable - Under Adjudication by BIA'
    WHEN `Case Category` = '[3] Deportable - Administratively Final Order' THEN 'Deportable - Administratively Final Order'
    WHEN `Case Category` = '[5A] Referred for Investigation - No Show for Hearing - No Final Order' THEN 'Referred for Investigation - No Show for Hearing - No Final Order'
    WHEN `Case Category` = '[5B] Removable - ICE Fugitive' THEN 'Removable - ICE Fugitive'
    WHEN `Case Category` = '[5C] Relief Granted - Withholding of Deportation / Removal' THEN 'Relief Granted - Withholding of Deportation / Removal'
    WHEN `Case Category` = '[5D] Final Order of Deportation / Removal - Deferred Action Granted' THEN 'Final Order of Deportation / Removal - Deferred Action Granted'
    WHEN `Case Category` = '[5E] Relief Granted - Extended Voluntary Departure' THEN 'Relief Granted - Extended Voluntary Departure'
    WHEN `Case Category` = '[5F] Unable to Obtain Travel Document' THEN 'Unable to Obtain Travel Document'
    WHEN `Case Category` = '[8A] Excludable / Inadmissible - Hearing Not Commenced' THEN 'Excludable / Inadmissible - Hearing Not Commenced'
    WHEN `Case Category` = '[8B] Excludable / Inadmissible - Under Adjudication by IJ' THEN 'Excludable / Inadmissible - Under Adjudication by IJ'
    WHEN `Case Category` = '[8C] Excludable / Inadmissible - Administrative Final Order Issued' THEN 'Excludable / Inadmissible - Administrative Final Order Issued'
    WHEN `Case Category` = '[8D] Excludable / Inadmissible - Under Adjudication by BIA' THEN 'Excludable / Inadmissible - Under Adjudication by BIA'
    WHEN `Case Category` = '[8E] Inadmissible - ICE Fugitive' THEN 'Inadmissible - ICE Fugitive'
    WHEN `Case Category` = '[8F] Expedited Removal' THEN 'Expedited Removal'
    WHEN `Case Category` = '[8G] Expedited Removal - Credible Fear Referral' THEN 'Expedited Removal - Credible Fear Referral'
    WHEN `Case Category` = '[8H] Expedited Removal - Status Claim Referral' THEN 'Expedited Removal - Status Claim Referral'
    WHEN `Case Category` = '[8I] Inadmissible - ICE Fugitive - Expedited Removal' THEN 'Inadmissible - ICE Fugitive - Expedited Removal'
    WHEN `Case Category` = '[8K] Expedited Removal Terminated due to Credible Fear Finding / NTA Issued' THEN 'Expedited Removal Terminated due to Credible Fear Finding / NTA Issued'
    WHEN `Case Category` = '[9] VR Under Safeguards' THEN 'VR Under Safeguards'
    ELSE `Case Category`
END
WHERE `Case Category` IN ('[10] Visa Waiver Deportation / Removal', '[11] Administrative Deportation / Removal', '[12] Judicial Deportation / Removal',
'[13] Section 250 Removal', '[14] Crewmen, Stowaways, S-Visa Holders, 235(c) Cases', '[15] Terrorist Court Case (Title 5)', '[16] Reinstated Final Order',
'[1A] Voluntary Departure - Un-Expired and Un-Extended Departure Period', '[1B] Voluntary Departure - Extended Departure Period', '[2A] Deportable - Under Adjudication by IJ',
'[2B] Deportable - Under Adjudication by BIA', '[3] Deportable - Administratively Final Order', '[5A] Referred for Investigation - No Show for Hearing - No Final Order', 
'[5B] Removable - ICE Fugitive', '[5C] Relief Granted - Withholding of Deportation / Removal', '[5D] Final Order of Deportation / Removal - Deferred Action Granted', 
'[5E] Relief Granted - Extended Voluntary Departure', '[5F] Unable to Obtain Travel Document', '[8A] Excludable / Inadmissible - Hearing Not Commenced', 
'[8B] Excludable / Inadmissible - Under Adjudication by IJ', '[8C] Excludable / Inadmissible - Administrative Final Order Issued', 
'[8D] Excludable / Inadmissible - Under Adjudication by BIA', '[8E] Inadmissible - ICE Fugitive', '[8F] Expedited Removal', '[8G] Expedited Removal - Credible Fear Referral', 
'[8H] Expedited Removal - Status Claim Referral', '[8I] Inadmissible - ICE Fugitive - Expedited Removal', 
'[8K] Expedited Removal Terminated due to Credible Fear Finding / NTA Issued', '[9] VR Under Safeguards');

SELECT DISTINCT `Departed Date`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Departed Date` = STR_TO_DATE(`Departed Date`, '%m/%d/%Y')
WHERE `Departed Date` <> '';

SELECT DISTINCT `Departure Country`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Final Order Yes No`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Final Order Date`
FROM ice_arrested_list_editable_2
ORDER BY 1;

UPDATE ice_arrested_list_editable_2
SET `Final Order Date` = STR_TO_DATE(`Final Order Date`, '%m/%d/%Y')
WHERE `Final Order Date` <> '';

SELECT * FROM ice_arrested_list_editable_2;

SELECT DISTINCT `Birth Date`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Birth Year`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Citizenship Country`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Gender`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Apprehension Site Landmark`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Alien File Number`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `EID Case ID`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `EID Subject ID`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Unique Identifier`
FROM ice_arrested_list_editable_2
ORDER BY 1;

/* Data standardisation done */

/* Working with null/blank values */

SELECT * FROM ice_arrested_list_editable_2;

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension Date` IS NULL
OR `Apprehension Date` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension State` IS NULL
OR `Apprehension State` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension County` IS NULL
OR `Apprehension County` = '';

SELECT DISTINCT `Apprehension State` FROM ice_arrested_list_editable_2
WHERE `Apprehension AOR` IS NULL
OR `Apprehension AOR` = '';

UPDATE ice_arrested_list_editable_2
SET `Apprehension AOR` = 
	CASE
        WHEN `Apprehension State` = 'ARIZONA' THEN 'Phoenix'
        WHEN `Apprehension State` = 'FLORIDA' THEN 'Miami'
        WHEN `Apprehension State` = 'ILLINOIS' THEN 'Chicago'
        WHEN `Apprehension State` = 'PENNSYLVANIA' THEN 'Philadelphia'
        WHEN `Apprehension State` = 'SOUTH CAROLINA' THEN 'Atlanta'
        WHEN `Apprehension State` = 'GEORGIA' THEN 'Atlanta'
        WHEN `Apprehension State` = 'TENNESSEE' THEN 'New Orleans'
        WHEN `Apprehension State` = 'MARYLAND' THEN 'Baltimore'
        WHEN `Apprehension State` = 'KANSAS' THEN 'Chicago'
        WHEN `Apprehension State` = 'ALABAMA' THEN 'New Orleans'
        WHEN `Apprehension State` = 'PUERTO RICO' THEN 'Miami'
        WHEN `Apprehension State` = 'NEW MEXICO' THEN 'El Paso'
        WHEN `Apprehension State` = 'LOUISIANA' THEN 'New Orleans'
        WHEN `Apprehension State` = 'MINNESOTA' THEN 'St. Paul'
        WHEN `Apprehension State` = 'WASHINGTON' THEN 'Seattle'
        WHEN `Apprehension State` = 'ARKANSAS' THEN 'New Orleans'
        WHEN `Apprehension State` = 'INDIANA' THEN 'Chicago'
        WHEN `Apprehension State` = 'MASSACHUSETTS' THEN 'Boston'
        WHEN `Apprehension State` = 'UTAH' THEN 'Salt Lake City'
        WHEN `Apprehension State` = 'NEW JERSEY' THEN 'Newark'
        WHEN `Apprehension State` = 'VIRGINIA' THEN 'Washington'
        WHEN `Apprehension State` = 'NEVADA' THEN 'Salt Lake City'
        WHEN `Apprehension State` = 'COLORADO' THEN 'Denver'
        ELSE `Apprehension AOR`
    END
WHERE `Apprehension AOR` = '' AND `Apprehension State` IN ('ARIZONA', 'FLORIDA', 'ILLINOIS', 'PENNSYLVANIA', 'SOUTH CAROLINA', 'GEORGIA', 'TENNESSEE', 'MARYLAND', 'KANSAS', 'ALABAMA', 'PUERTO RICO', 
'NEW MEXICO', 'LOUISIANA', 'MINNESOTA', 'WASHINGTON', 'ARKANSAS', 'INDIANA', 'MASSACHUSETTS', 'UTAH', 'NEW JERSEY', 'VIRGINIA', 'NEVADA', 'COLORADO');

SELECT DISTINCT `Apprehension AOR`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT * FROM ice_arrested_list_editable_2
WHERE `Final Program` IS NULL
OR `Final Program` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Final Program Group` IS NULL
OR `Final Program Group` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension Method` IS NULL
OR `Apprehension Method` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension Criminality` IS NULL
OR `Apprehension Criminality` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Case Status` IS NULL
OR `Case Status` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Case Category` IS NULL
OR `Case Category` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Departed Date` IS NULL
OR `Departed Date` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Departure Country` IS NULL
OR `Departure Country` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Final Order Yes No` IS NULL
OR `Final Order Yes No` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Final Order Date` IS NULL
OR `Final Order Date` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Birth Date` IS NULL
OR `Birth Date` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Birth Year` IS NULL
OR `Birth Year` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Citizenship Country` IS NULL
OR `Citizenship Country` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Gender` IS NULL
OR `Gender` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Apprehension Site Landmark` IS NULL
OR `Apprehension Site Landmark` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Alien File Number` IS NULL
OR `Alien File Number` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `EID Case ID` IS NULL
OR `EID Case ID` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `EID Subject ID` IS NULL
OR `EID Subject ID` = '';

SELECT * FROM ice_arrested_list_editable_2
WHERE `Unique Identifier` IS NULL
OR `Unique Identifier` = '';

/* working with null and blank values done */

/* removing irrelevant rows and columns below */
SELECT * FROM ice_arrested_list_editable_2;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Apprehension County`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Final Program Group`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Birth Date`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Alien File Number`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `EID Case ID`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Apprehension Site Landmark`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `EID Subject ID`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN row_num;

SELECT DISTINCT `Final Program`
FROM ice_arrested_list_editable_2
ORDER BY 1;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Final Program`;

SELECT DISTINCT `Apprehension Method`
FROM ice_arrested_list_editable_2
ORDER BY 1;

SELECT DISTINCT `Apprehension State`
FROM ice_arrested_list_editable_2
ORDER BY 1;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Apprehension State`;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Final Order Yes No` = ''
OR `Final Order Yes No` IS NULL;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Apprehension AOR` = ''
OR `Apprehension AOR` IS NULL;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Final Order Date`;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Departure Country` = ''
OR `Departure Country` IS NULL;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Departure Country`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Departed Date`;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Case Category` = ''
OR `Case Category` IS NULL;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Case Category`;

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Case Status`;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Birth Year` = ''
OR `Birth Year` IS NULL;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Gender` = ''
OR `Gender` IS NULL;

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Unique Identifier` = ''
OR `Unique Identifier` IS NULL;

DELETE
FROM ice_arrested_list_editable_2
WHERE `Apprehension AOR` = '';

SELECT COUNT(*) FROM ice_arrested_list_editable_2
WHERE `Citizenship Country` = ''
OR `Citizenship Country` IS NULL;

DELETE
FROM ice_arrested_list_editable_2
WHERE `Final Order Yes No` = '';

ALTER TABLE ice_arrested_list_editable_2
DROP COLUMN `Unique Identifier`;
/*
======================================================================
Create Databases
======================================================================
Project     :	NAVA Data Warehouse
Script      :	init_database.sql

Description :
Initializes the NAVA Data Warehouse by creating the three project
databases used throughout the ETL process.

Databases:
- NAVA_raw 		    : Raw imported data
- NAVA_clean 	  	: Cleaned and standardized data
- NAVA_analytics 	: Analytics-ready views

WARNING:
This script drops existing databases before recreating them.
All existing data will be permanently deleted.
======================================================================
*/


-- ====================================================================
-- Drop existing databases
-- ====================================================================

DROP DATABASE IF EXISTS NAVA_raw;
DROP DATABASE IF EXISTS NAVA_clean;
DROP DATABASE IF EXISTS NAVA_analytics;

-- ====================================================================
-- Create databases
-- ====================================================================

CREATE DATABASE NAVA_raw;
CREATE DATABASE NAVA_clean;
CREATE DATABASE NAVA_analytics;

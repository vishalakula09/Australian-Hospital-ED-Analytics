
-- ============================================================
-- PROJECT: Australian Hospital Emergency Department Analytics
-- FILE: 01_database_setup.sql
-- PURPOSE: Create and select the MySQL project database
-- ============================================================

-- Step 1: Create the database if it does not already exist
CREATE DATABASE IF NOT EXISTS australian_hospital_ed;

-- Step 2: Select the database for subsequent SQL operations
USE australian_hospital_ed;

-- Step 3: Verify the currently selected database
SELECT DATABASE() AS current_database;

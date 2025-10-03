/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    - Creates a new database named 'dwh'.
    - If it already exists, it will be dropped and recreated.
    - Creates three schemas: 'bronze', 'silver', and 'gold'.

⚠️ WARNING:
    Running this script will DROP the 'dwh' database 
    if it exists. All data will be permanently deleted. 
    Ensure you have backups before running this script.
=============================================================
*/

USE master;
GO

-- Drop and recreate the 'dwh' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'dwh')
BEGIN
    ALTER DATABASE dwh SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE dwh;
END;
GO

-- Create the 'dwh' database
CREATE DATABASE dwh;
GO

USE dwh;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

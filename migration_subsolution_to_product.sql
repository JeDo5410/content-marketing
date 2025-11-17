-- =============================================
-- Migration Script: Sub Solution to Product Rename
-- Description: Rename Sub Solution terminology to Product
-- Date: 2025-11-17
-- =============================================
-- IMPORTANT: Review this script before executing on production!
-- This script will rename 1 table, 4 columns, 1 foreign key, and 2 unique constraints
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Starting Sub Solution to Product Migration';
    PRINT '========================================';
    PRINT '';

    -- =============================================
    -- STEP 1: Drop Foreign Key Constraints
    -- =============================================
    PRINT 'STEP 1: Dropping Foreign Key Constraints...';

    -- Drop FK from contentmarketing_sub_solutions_master to contentmarketing_solution_master
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_sub_solution_solution_id_test')
        ALTER TABLE test_contentmarketing.contentmarketing_sub_solutions_master DROP CONSTRAINT fk_sub_solution_solution_id_test;
    PRINT '  - Dropped fk_sub_solution_solution_id_test';

    PRINT 'STEP 1: Completed - Foreign key dropped';
    PRINT '';

    -- =============================================
    -- STEP 2: Drop Unique Constraints
    -- =============================================
    PRINT 'STEP 2: Dropping Unique Constraints...';

    -- Drop unique constraints (will recreate later with new names)
    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'unique_sub_solution_code_test')
        ALTER TABLE test_contentmarketing.contentmarketing_sub_solutions_master DROP CONSTRAINT unique_sub_solution_code_test;
    PRINT '  - Dropped unique_sub_solution_code_test';

    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'unique_sub_solution_name_test')
        ALTER TABLE test_contentmarketing.contentmarketing_sub_solutions_master DROP CONSTRAINT unique_sub_solution_name_test;
    PRINT '  - Dropped unique_sub_solution_name_test';

    PRINT 'STEP 2: Completed - Unique constraints dropped';
    PRINT '';

    -- =============================================
    -- STEP 3: Rename Table
    -- =============================================
    PRINT 'STEP 3: Renaming Table...';

    EXEC sp_rename 'test_contentmarketing.contentmarketing_sub_solutions_master', 'contentmarketing_product_master';
    PRINT '  - Renamed contentmarketing_sub_solutions_master to contentmarketing_product_master';

    PRINT 'STEP 3: Completed - Table renamed';
    PRINT '';

    -- =============================================
    -- STEP 4: Rename Columns
    -- =============================================
    PRINT 'STEP 4: Renaming Columns...';

    -- Rename columns in the renamed table
    EXEC sp_rename 'test_contentmarketing.contentmarketing_product_master.sub_solution_id', 'product_id', 'COLUMN';
    PRINT '  - Renamed contentmarketing_product_master.sub_solution_id to product_id';

    EXEC sp_rename 'test_contentmarketing.contentmarketing_product_master.sub_solution_name', 'product_name', 'COLUMN';
    PRINT '  - Renamed contentmarketing_product_master.sub_solution_name to product_name';

    EXEC sp_rename 'test_contentmarketing.contentmarketing_product_master.sub_solution_code', 'product_code', 'COLUMN';
    PRINT '  - Renamed contentmarketing_product_master.sub_solution_code to product_code';

    -- Rename in ssc_main table (or smc_main if you already ran the SSC to SMC migration)
    -- Check which table exists and rename accordingly
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ssc_main')
    BEGIN
        EXEC sp_rename 'test_contentmarketing.ssc_main.sub_solution_id', 'product_id', 'COLUMN';
        PRINT '  - Renamed ssc_main.sub_solution_id to product_id';
    END
    ELSE IF EXISTS (SELECT * FROM sys.tables WHERE name = 'smc_main')
    BEGIN
        EXEC sp_rename 'test_contentmarketing.smc_main.sub_solution_id', 'product_id', 'COLUMN';
        PRINT '  - Renamed smc_main.sub_solution_id to product_id';
    END

    PRINT 'STEP 4: Completed - All columns renamed';
    PRINT '';

    -- =============================================
    -- STEP 5: Recreate Unique Constraints
    -- =============================================
    PRINT 'STEP 5: Recreating Unique Constraints...';

    -- Recreate unique constraint for product_code
    ALTER TABLE test_contentmarketing.contentmarketing_product_master
        ADD CONSTRAINT unique_product_code_test UNIQUE (solution_id, product_code);
    PRINT '  - Created unique_product_code_test';

    -- Recreate unique constraint for product_name
    ALTER TABLE test_contentmarketing.contentmarketing_product_master
        ADD CONSTRAINT unique_product_name_test UNIQUE (solution_id, product_name);
    PRINT '  - Created unique_product_name_test';

    PRINT 'STEP 5: Completed - Unique constraints recreated';
    PRINT '';

    -- =============================================
    -- STEP 6: Recreate Foreign Key Constraint
    -- =============================================
    PRINT 'STEP 6: Recreating Foreign Key Constraint...';

    -- FK from contentmarketing_product_master to contentmarketing_solution_master
    ALTER TABLE test_contentmarketing.contentmarketing_product_master
        ADD CONSTRAINT fk_product_solution_id_test
        FOREIGN KEY (solution_id) REFERENCES test_contentmarketing.contentmarketing_solution_master(solution_id);
    PRINT '  - Created fk_product_solution_id_test';

    PRINT 'STEP 6: Completed - Foreign key recreated';
    PRINT '';

    -- =============================================
    -- TRANSACTION COMPLETE
    -- =============================================
    PRINT '========================================';
    PRINT 'Migration Completed Successfully!';
    PRINT '========================================';
    PRINT '';
    PRINT 'Summary:';
    PRINT '  - 1 Table renamed (contentmarketing_sub_solutions_master to contentmarketing_product_master)';
    PRINT '  - 4 Columns renamed (sub_solution_* to product_*)';
    PRINT '  - 1 Foreign key dropped and recreated';
    PRINT '  - 2 Unique constraints dropped and recreated';
    PRINT '';
    PRINT 'Database now uses Product terminology instead of Sub Solution.';
    PRINT '';

    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';

END TRY
BEGIN CATCH
    -- =============================================
    -- ERROR HANDLING
    -- =============================================
    PRINT '';
    PRINT '========================================';
    PRINT 'ERROR OCCURRED - ROLLING BACK CHANGES';
    PRINT '========================================';
    PRINT '';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT '';

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'All changes have been rolled back.';
    PRINT 'Database remains in original state.';

    -- Re-throw the error
    THROW;
END CATCH;

GO

-- =============================================
-- POST-MIGRATION VERIFICATION
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'POST-MIGRATION VERIFICATION';
PRINT '========================================';
PRINT '';
PRINT 'Tables with PRODUCT in name:';
SELECT name FROM sys.tables WHERE name LIKE '%product%' ORDER BY name;
PRINT '';
PRINT 'Columns with PRODUCT in name:';
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%product%'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
PRINT '';
PRINT 'Foreign keys with PRODUCT in name:';
SELECT name FROM sys.foreign_keys WHERE name LIKE '%product%' ORDER BY name;
PRINT '';
PRINT 'Any remaining SUB_SOLUTION references (should be empty):';
SELECT name FROM sys.tables WHERE name LIKE '%sub_solution%' ORDER BY name;
PRINT '';
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%sub_solution%'
ORDER BY TABLE_NAME;
PRINT '';

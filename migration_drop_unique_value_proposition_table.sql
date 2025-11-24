-- =============================================
-- Migration Script: Drop Unique Value Proposition Table
-- Description: Remove ssc_unique_value_proposition (or smc_unique_value_proposition) table
-- Date: 2025-11-17
-- =============================================
-- WARNING: This will permanently delete the table and all its data!
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Dropping Unique Value Proposition Table';
    PRINT '========================================';
    PRINT '';

    -- Check which naming convention is being used
    DECLARE @TableName VARCHAR(100);

    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'smc_unique_value_proposition')
        SET @TableName = 'smc_unique_value_proposition';
    ELSE IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ssc_unique_value_proposition')
        SET @TableName = 'ssc_unique_value_proposition';
    ELSE
    BEGIN
        PRINT 'Table not found (neither ssc_unique_value_proposition nor smc_unique_value_proposition exists)';
        PRINT 'Nothing to do.';
        COMMIT TRANSACTION;
        RETURN;
    END

    PRINT 'Found table: ' + @TableName;
    PRINT '';

    -- =============================================
    -- STEP 1: Drop Foreign Key Constraint
    -- =============================================
    PRINT 'STEP 1: Dropping foreign key constraint...';

    -- For SSC version
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_unique_value_proposition_ssc_id_test')
    BEGIN
        ALTER TABLE test_contentmarketing.ssc_unique_value_proposition
            DROP CONSTRAINT fk_ssc_unique_value_proposition_ssc_id_test;
        PRINT '  - Dropped fk_ssc_unique_value_proposition_ssc_id_test';
    END

    -- For SMC version
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_smc_unique_value_proposition_smc_id_test')
    BEGIN
        ALTER TABLE test_contentmarketing.smc_unique_value_proposition
            DROP CONSTRAINT fk_smc_unique_value_proposition_smc_id_test;
        PRINT '  - Dropped fk_smc_unique_value_proposition_smc_id_test';
    END

    PRINT 'STEP 1: Completed';
    PRINT '';

    -- =============================================
    -- STEP 2: Drop the Table
    -- =============================================
    PRINT 'STEP 2: Dropping table...';

    IF @TableName = 'ssc_unique_value_proposition'
    BEGIN
        DROP TABLE test_contentmarketing.ssc_unique_value_proposition;
        PRINT '  - Dropped ssc_unique_value_proposition table';
    END
    ELSE IF @TableName = 'smc_unique_value_proposition'
    BEGIN
        DROP TABLE test_contentmarketing.smc_unique_value_proposition;
        PRINT '  - Dropped smc_unique_value_proposition table';
    END

    PRINT 'STEP 2: Completed';
    PRINT '';

    -- =============================================
    -- TRANSACTION COMPLETE
    -- =============================================
    PRINT '========================================';
    PRINT 'Migration Completed Successfully!';
    PRINT '========================================';
    PRINT '';
    PRINT 'Summary:';
    PRINT '  - Foreign key constraint dropped';
    PRINT '  - ' + @TableName + ' table dropped';
    PRINT '  - All data permanently deleted';
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
    PRINT 'Table remains in database.';

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

PRINT 'Checking if table still exists:';
SELECT name
FROM sys.tables
WHERE name LIKE '%unique_value_proposition%';

PRINT '';
PRINT 'If no results above, table was successfully dropped.';
PRINT '';

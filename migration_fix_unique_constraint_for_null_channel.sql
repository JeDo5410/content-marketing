-- =============================================
-- Migration Script: Fix Unique Constraint for NULL Channel
-- Description: Allow NULL channel_id in asset_channel_specification
-- Date: 2025-11-17
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Fixing Unique Constraint for NULL Channel';
    PRINT '========================================';
    PRINT '';

    -- Drop existing unique constraint
    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'unique_asset_channel_spec')
    BEGIN
        ALTER TABLE test_contentmarketing.asset_channel_specification
            DROP CONSTRAINT unique_asset_channel_spec;
        PRINT '  - Dropped old unique_asset_channel_spec constraint';
    END

    -- Make channel_id nullable (if not already)
    ALTER TABLE test_contentmarketing.asset_channel_specification
        ALTER COLUMN channel_id INT NULL;
    PRINT '  - Made channel_id nullable';

    -- Create unique index that handles NULL values
    -- This allows multiple rows with NULL channel_id but prevents duplicates for non-NULL values
    CREATE UNIQUE INDEX unique_asset_channel_spec
        ON test_contentmarketing.asset_channel_specification(asset_type_id, channel_id)
        WHERE channel_id IS NOT NULL;
    PRINT '  - Created new unique index (allows NULL channel_id)';

    -- For assets with NULL channel_id, ensure only one spec per asset_type
    -- Create additional unique index for NULL channel_id cases
    CREATE UNIQUE INDEX unique_asset_null_channel
        ON test_contentmarketing.asset_channel_specification(asset_type_id)
        WHERE channel_id IS NULL;
    PRINT '  - Created unique index for NULL channel cases';

    PRINT '';
    PRINT 'Migration completed successfully!';
    PRINT 'Now you can have:';
    PRINT '  - One spec per asset-type when channel is NULL';
    PRINT '  - One spec per asset-type + channel combination when channel is specified';

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

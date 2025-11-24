-- =============================================
-- Migration Script: Add Tool Columns to asset_channel_specification
-- Description: Add columns for tool URLs and button text
-- Date: 2025-11-17
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Adding Tool Columns to asset_channel_specification';
    PRINT '========================================';
    PRINT '';

    -- Add tool_url column
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_NAME = 'asset_channel_specification'
                   AND COLUMN_NAME = 'tool_url')
    BEGIN
        ALTER TABLE test_contentmarketing.asset_channel_specification
            ADD tool_url VARCHAR(500) NULL;
        PRINT '  - Added tool_url column';
    END
    ELSE
        PRINT '  - tool_url column already exists';

    -- Add tool_button_text column
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_NAME = 'asset_channel_specification'
                   AND COLUMN_NAME = 'tool_button_text')
    BEGIN
        ALTER TABLE test_contentmarketing.asset_channel_specification
            ADD tool_button_text VARCHAR(100) NULL;
        PRINT '  - Added tool_button_text column';
    END
    ELSE
        PRINT '  - tool_button_text column already exists';

    -- Add tool_url_2 column (for assets with multiple tools)
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_NAME = 'asset_channel_specification'
                   AND COLUMN_NAME = 'tool_url_2')
    BEGIN
        ALTER TABLE test_contentmarketing.asset_channel_specification
            ADD tool_url_2 VARCHAR(500) NULL;
        PRINT '  - Added tool_url_2 column';
    END
    ELSE
        PRINT '  - tool_url_2 column already exists';

    -- Add tool_button_text_2 column
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_NAME = 'asset_channel_specification'
                   AND COLUMN_NAME = 'tool_button_text_2')
    BEGIN
        ALTER TABLE test_contentmarketing.asset_channel_specification
            ADD tool_button_text_2 VARCHAR(100) NULL;
        PRINT '  - Added tool_button_text_2 column';
    END
    ELSE
        PRINT '  - tool_button_text_2 column already exists';

    PRINT '';
    PRINT 'Migration completed successfully!';
    PRINT 'Tool columns added to support tool URLs and button text.';

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

GO

-- Verify columns
PRINT '';
PRINT 'Columns in asset_channel_specification:';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'asset_channel_specification'
ORDER BY ORDINAL_POSITION;

-- =============================================
-- Migration Script: Create asset_channel_specification Table
-- Description: Replace content_asset_builder with new specification table
-- Date: 2025-11-17
-- =============================================
-- IMPORTANT: Review this script before executing on production!
-- This will DROP the content_asset_builder table and create a new table
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Starting Asset Channel Specification Migration';
    PRINT '========================================';
    PRINT '';

    -- =============================================
    -- STEP 1: Drop Dependent Foreign Keys
    -- =============================================
    PRINT 'STEP 1: Dropping dependent foreign keys...';

    -- Drop FK from content_asset_result to content_asset_builder
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_result_builder')
        ALTER TABLE test_contentmarketing.content_asset_result DROP CONSTRAINT fk_result_builder;
    PRINT '  - Dropped fk_result_builder from content_asset_result';

    PRINT 'STEP 1: Completed - Dependent foreign keys dropped';
    PRINT '';

    -- =============================================
    -- STEP 2: Drop content_asset_builder Table
    -- =============================================
    PRINT 'STEP 2: Dropping content_asset_builder table...';

    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'content_asset_builder')
        DROP TABLE test_contentmarketing.content_asset_builder;
    PRINT '  - Dropped content_asset_builder table';

    PRINT 'STEP 2: Completed - Old table dropped';
    PRINT '';

    -- =============================================
    -- STEP 3: Create asset_channel_specification Table
    -- =============================================
    PRINT 'STEP 3: Creating asset_channel_specification table...';

    CREATE TABLE test_contentmarketing.asset_channel_specification (
        -- Primary Key
        spec_id BIGINT IDENTITY(1,1) PRIMARY KEY,

        -- Foreign Keys
        asset_type_id INT NOT NULL,
        channel_id INT NOT NULL,

        -- File Format & Media Specs
        file_format VARCHAR(50) NULL,
        paper_size VARCHAR(100) NULL,
        audio_quality VARCHAR(50) NULL,
        duration_min VARCHAR(20) NULL,
        duration_max VARCHAR(20) NULL,

        -- Word Count Fields - Headline
        headline_word_count_min INT NULL,
        headline_word_count_max INT NULL,

        -- Word Count Fields - Subheadline
        subheadline_word_count_min INT NULL,
        subheadline_word_count_max INT NULL,

        -- Word Count Fields - Body
        body_word_count_min INT NULL,
        body_word_count_max INT NULL,

        -- Word Count Fields - CTA
        cta_word_count_min INT NULL,
        cta_word_count_max INT NULL,

        -- Additional Constraints
        additional_specs NVARCHAR(MAX) NULL,

        -- Tool Information
        tool_url VARCHAR(500) NULL,
        tool_button_text VARCHAR(100) NULL,
        tool_url_2 VARCHAR(500) NULL,
        tool_button_text_2 VARCHAR(100) NULL,

        -- Metadata
        status VARCHAR(20) NOT NULL DEFAULT 'active',
        created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        created_by VARCHAR(150) NULL,
        updated_at DATETIME2 NULL,
        updated_by VARCHAR(150) NULL,

        -- Unique Constraint: One spec per asset-type + channel combination
        CONSTRAINT unique_asset_channel_spec UNIQUE (asset_type_id, channel_id)
    );

    PRINT '  - Created asset_channel_specification table';
    PRINT '';

    -- =============================================
    -- STEP 4: Create Foreign Key Constraints
    -- =============================================
    PRINT 'STEP 4: Creating foreign key constraints...';

    -- FK to asset_type
    ALTER TABLE test_contentmarketing.asset_channel_specification
        ADD CONSTRAINT fk_spec_asset_type
        FOREIGN KEY (asset_type_id) REFERENCES test_contentmarketing.asset_type(asset_type_id);
    PRINT '  - Created fk_spec_asset_type';

    -- FK to contentmarketing_channels_master
    ALTER TABLE test_contentmarketing.asset_channel_specification
        ADD CONSTRAINT fk_spec_channel
        FOREIGN KEY (channel_id) REFERENCES test_contentmarketing.contentmarketing_channels_master(channel_id);
    PRINT '  - Created fk_spec_channel';

    PRINT 'STEP 4: Completed - Foreign keys created';
    PRINT '';

    -- =============================================
    -- STEP 5: Add Indexes for Performance
    -- =============================================
    PRINT 'STEP 5: Creating indexes...';

    -- Index on asset_type_id for faster lookups
    CREATE NONCLUSTERED INDEX idx_spec_asset_type
        ON test_contentmarketing.asset_channel_specification(asset_type_id);
    PRINT '  - Created idx_spec_asset_type';

    -- Index on channel_id for faster lookups
    CREATE NONCLUSTERED INDEX idx_spec_channel
        ON test_contentmarketing.asset_channel_specification(channel_id);
    PRINT '  - Created idx_spec_channel';

    -- Index on status for filtering active specs
    CREATE NONCLUSTERED INDEX idx_spec_status
        ON test_contentmarketing.asset_channel_specification(status);
    PRINT '  - Created idx_spec_status';

    PRINT 'STEP 5: Completed - Indexes created';
    PRINT '';

    -- =============================================
    -- TRANSACTION COMPLETE
    -- =============================================
    PRINT '========================================';
    PRINT 'Migration Completed Successfully!';
    PRINT '========================================';
    PRINT '';
    PRINT 'Summary:';
    PRINT '  - Dropped content_asset_builder table';
    PRINT '  - Created asset_channel_specification table';
    PRINT '  - Added 2 foreign key constraints';
    PRINT '  - Added 3 performance indexes';
    PRINT '  - Added unique constraint for asset-type + channel combination';
    PRINT '';
    PRINT 'New Table Columns:';
    PRINT '  - spec_id (Primary Key)';
    PRINT '  - asset_type_id, channel_id (Foreign Keys)';
    PRINT '  - File specs: file_format, paper_size, audio_quality, duration_min, duration_max';
    PRINT '  - Word counts: headline, subheadline, body, cta (all with min/max)';
    PRINT '  - additional_specs (for complex notes)';
    PRINT '  - Tool info: tool_url, tool_button_text, tool_url_2, tool_button_text_2';
    PRINT '  - Metadata: status, created_at, created_by, updated_at, updated_by';
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

PRINT 'New table exists:';
SELECT name, create_date
FROM sys.tables
WHERE name = 'asset_channel_specification';
PRINT '';

PRINT 'Columns in asset_channel_specification:';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'asset_channel_specification'
ORDER BY ORDINAL_POSITION;
PRINT '';

PRINT 'Foreign keys on asset_channel_specification:';
SELECT name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('test_contentmarketing.asset_channel_specification')
ORDER BY name;
PRINT '';

PRINT 'Indexes on asset_channel_specification:';
SELECT name, type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('test_contentmarketing.asset_channel_specification')
ORDER BY name;
PRINT '';

PRINT 'Old table check (should be empty):';
SELECT name
FROM sys.tables
WHERE name = 'content_asset_builder';
PRINT '';

-- =============================================
-- SAMPLE INSERT STATEMENT (commented out)
-- =============================================
/*
-- Example: Insert a specification for Banner on Facebook
INSERT INTO test_contentmarketing.asset_channel_specification (
    asset_type_id,
    channel_id,
    file_format,
    paper_size,
    headline_word_count_min,
    headline_word_count_max,
    body_word_count_min,
    body_word_count_max,
    cta_word_count_max,
    additional_specs,
    created_by
) VALUES (
    25, -- Banner asset type
    1,  -- Facebook channel
    'PNG',
    NULL,
    5,
    10,
    50,
    100,
    5,
    'Image text <20%; Max 3 bullet points',
    'admin'
);
*/

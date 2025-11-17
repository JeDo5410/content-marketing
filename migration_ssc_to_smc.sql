-- =============================================
-- Migration Script: SSC to SMC Rename
-- Description: Rename Solution Sales Canvas to Solution Marketing Canvas
-- Date: 2025-11-17
-- =============================================
-- IMPORTANT: Review this script before executing on production!
-- This script will rename 8 tables, 12 columns, and 12 foreign keys
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Starting SSC to SMC Migration';
    PRINT '========================================';
    PRINT '';

    -- =============================================
    -- STEP 1: Drop All Foreign Key Constraints
    -- =============================================
    PRINT 'STEP 1: Dropping Foreign Key Constraints...';

    -- Drop FK from content_asset_builder
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_builder_ssc_id')
        ALTER TABLE test_contentmarketing.content_asset_builder DROP CONSTRAINT fk_builder_ssc_id;
    PRINT '  - Dropped fk_builder_ssc_id';

    -- Drop FK from content_topic
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_content_topic_ssc_id')
        ALTER TABLE test_contentmarketing.content_topic DROP CONSTRAINT fk_content_topic_ssc_id;
    PRINT '  - Dropped fk_content_topic_ssc_id';

    -- Drop FK from cta
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_cta_ssc_id')
        ALTER TABLE test_contentmarketing.cta DROP CONSTRAINT fk_cta_ssc_id;
    PRINT '  - Dropped fk_cta_ssc_id';

    -- Drop FK from ssc_funnel_mapping
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_funnel_mapping_ssc_id')
        ALTER TABLE test_contentmarketing.ssc_funnel_mapping DROP CONSTRAINT fk_funnel_mapping_ssc_id;
    PRINT '  - Dropped fk_funnel_mapping_ssc_id';

    -- Drop FK from ssc_channels
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_channels_ssc_id')
        ALTER TABLE test_contentmarketing.ssc_channels DROP CONSTRAINT fk_ssc_channels_ssc_id;
    PRINT '  - Dropped fk_ssc_channels_ssc_id';

    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_channels_channel_id')
        ALTER TABLE test_contentmarketing.ssc_channels DROP CONSTRAINT fk_ssc_channels_channel_id;
    PRINT '  - Dropped fk_ssc_channels_channel_id';

    -- Drop FK from ssc_main
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_solution_id_test')
        ALTER TABLE test_contentmarketing.ssc_main DROP CONSTRAINT fk_ssc_solution_id_test;
    PRINT '  - Dropped fk_ssc_solution_id_test';

    -- Drop FK from ssc_personas
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_personas_ssc_id_test')
        ALTER TABLE test_contentmarketing.ssc_personas DROP CONSTRAINT fk_ssc_personas_ssc_id_test;
    PRINT '  - Dropped fk_ssc_personas_ssc_id_test';

    -- Drop FK from ssc_problem_statements
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_problem_statements_ssc_id_test')
        ALTER TABLE test_contentmarketing.ssc_problem_statements DROP CONSTRAINT fk_ssc_problem_statements_ssc_id_test;
    PRINT '  - Dropped fk_ssc_problem_statements_ssc_id_test';

    -- Drop FK from ssc_solution_features
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_solution_features_ssc_id_test')
        ALTER TABLE test_contentmarketing.ssc_solution_features DROP CONSTRAINT fk_ssc_solution_features_ssc_id_test;
    PRINT '  - Dropped fk_ssc_solution_features_ssc_id_test';

    -- Drop FK from ssc_unfair_advantage
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_unfair_advantage_ssc_id_test')
        ALTER TABLE test_contentmarketing.ssc_unfair_advantage DROP CONSTRAINT fk_ssc_unfair_advantage_ssc_id_test;
    PRINT '  - Dropped fk_ssc_unfair_advantage_ssc_id_test';

    -- Drop FK from ssc_unique_value_proposition
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_ssc_unique_value_proposition_ssc_id_test')
        ALTER TABLE test_contentmarketing.ssc_unique_value_proposition DROP CONSTRAINT fk_ssc_unique_value_proposition_ssc_id_test;
    PRINT '  - Dropped fk_ssc_unique_value_proposition_ssc_id_test';

    PRINT 'STEP 1: Completed - All foreign keys dropped';
    PRINT '';

    -- =============================================
    -- STEP 2: Rename Tables
    -- =============================================
    PRINT 'STEP 2: Renaming Tables...';

    EXEC sp_rename 'test_contentmarketing.ssc_main', 'smc_main';
    PRINT '  - Renamed ssc_main to smc_main';

    EXEC sp_rename 'test_contentmarketing.ssc_channels', 'smc_channels';
    PRINT '  - Renamed ssc_channels to smc_channels';

    EXEC sp_rename 'test_contentmarketing.ssc_funnel_mapping', 'smc_funnel_mapping';
    PRINT '  - Renamed ssc_funnel_mapping to smc_funnel_mapping';

    EXEC sp_rename 'test_contentmarketing.ssc_personas', 'smc_personas';
    PRINT '  - Renamed ssc_personas to smc_personas';

    EXEC sp_rename 'test_contentmarketing.ssc_problem_statements', 'smc_problem_statements';
    PRINT '  - Renamed ssc_problem_statements to smc_problem_statements';

    EXEC sp_rename 'test_contentmarketing.ssc_solution_features', 'smc_solution_features';
    PRINT '  - Renamed ssc_solution_features to smc_solution_features';

    EXEC sp_rename 'test_contentmarketing.ssc_unfair_advantage', 'smc_unfair_advantage';
    PRINT '  - Renamed ssc_unfair_advantage to smc_unfair_advantage';

    EXEC sp_rename 'test_contentmarketing.ssc_unique_value_proposition', 'smc_unique_value_proposition';
    PRINT '  - Renamed ssc_unique_value_proposition to smc_unique_value_proposition';

    PRINT 'STEP 2: Completed - All tables renamed';
    PRINT '';

    -- =============================================
    -- STEP 3: Rename Columns
    -- =============================================
    PRINT 'STEP 3: Renaming Columns...';

    -- Rename ssc_id columns
    EXEC sp_rename 'test_contentmarketing.smc_main.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_main.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_main.ssc_url', 'smc_url', 'COLUMN';
    PRINT '  - Renamed smc_main.ssc_url to smc_url';

    EXEC sp_rename 'test_contentmarketing.smc_channels.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_channels.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_funnel_mapping.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_funnel_mapping.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_personas.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_personas.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_problem_statements.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_problem_statements.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_solution_features.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_solution_features.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_unfair_advantage.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_unfair_advantage.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.smc_unique_value_proposition.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed smc_unique_value_proposition.ssc_id to smc_id';

    -- Rename in other tables that reference ssc_id
    EXEC sp_rename 'test_contentmarketing.content_asset_builder.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed content_asset_builder.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.content_topic.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed content_topic.ssc_id to smc_id';

    EXEC sp_rename 'test_contentmarketing.cta.ssc_id', 'smc_id', 'COLUMN';
    PRINT '  - Renamed cta.ssc_id to smc_id';

    PRINT 'STEP 3: Completed - All columns renamed';
    PRINT '';

    -- =============================================
    -- STEP 4: Rename Unique Constraints
    -- =============================================
    PRINT 'STEP 4: Renaming Unique Constraints...';

    EXEC sp_rename 'test_contentmarketing.smc_channels.unique_ssc_channel_order', 'unique_smc_channel_order', 'INDEX';
    PRINT '  - Renamed unique_ssc_channel_order to unique_smc_channel_order';

    PRINT 'STEP 4: Completed - Unique constraints renamed';
    PRINT '';

    -- =============================================
    -- STEP 5: Recreate Foreign Key Constraints
    -- =============================================
    PRINT 'STEP 5: Recreating Foreign Key Constraints...';

    -- FK from content_asset_builder to smc_main
    ALTER TABLE test_contentmarketing.content_asset_builder
        ADD CONSTRAINT fk_builder_smc_id
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_builder_smc_id';

    -- FK from content_topic to smc_main
    ALTER TABLE test_contentmarketing.content_topic
        ADD CONSTRAINT fk_content_topic_smc_id
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_content_topic_smc_id';

    -- FK from cta to smc_main
    ALTER TABLE test_contentmarketing.cta
        ADD CONSTRAINT fk_cta_smc_id
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_cta_smc_id';

    -- FK from smc_funnel_mapping to smc_main
    ALTER TABLE test_contentmarketing.smc_funnel_mapping
        ADD CONSTRAINT fk_funnel_mapping_smc_id
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_funnel_mapping_smc_id';

    -- FK from smc_channels to smc_main
    ALTER TABLE test_contentmarketing.smc_channels
        ADD CONSTRAINT fk_smc_channels_smc_id
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_channels_smc_id';

    -- FK from smc_channels to contentmarketing_channels_master
    ALTER TABLE test_contentmarketing.smc_channels
        ADD CONSTRAINT fk_smc_channels_channel_id
        FOREIGN KEY (channel_id) REFERENCES test_contentmarketing.contentmarketing_channels_master(channel_id);
    PRINT '  - Created fk_smc_channels_channel_id';

    -- FK from smc_main to contentmarketing_solution_master
    ALTER TABLE test_contentmarketing.smc_main
        ADD CONSTRAINT fk_smc_solution_id_test
        FOREIGN KEY (solution_id) REFERENCES test_contentmarketing.contentmarketing_solution_master(solution_id);
    PRINT '  - Created fk_smc_solution_id_test';

    -- FK from smc_personas to smc_main
    ALTER TABLE test_contentmarketing.smc_personas
        ADD CONSTRAINT fk_smc_personas_smc_id_test
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_personas_smc_id_test';

    -- FK from smc_problem_statements to smc_main
    ALTER TABLE test_contentmarketing.smc_problem_statements
        ADD CONSTRAINT fk_smc_problem_statements_smc_id_test
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_problem_statements_smc_id_test';

    -- FK from smc_solution_features to smc_main
    ALTER TABLE test_contentmarketing.smc_solution_features
        ADD CONSTRAINT fk_smc_solution_features_smc_id_test
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_solution_features_smc_id_test';

    -- FK from smc_unfair_advantage to smc_main
    ALTER TABLE test_contentmarketing.smc_unfair_advantage
        ADD CONSTRAINT fk_smc_unfair_advantage_smc_id_test
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_unfair_advantage_smc_id_test';

    -- FK from smc_unique_value_proposition to smc_main
    ALTER TABLE test_contentmarketing.smc_unique_value_proposition
        ADD CONSTRAINT fk_smc_unique_value_proposition_smc_id_test
        FOREIGN KEY (smc_id) REFERENCES test_contentmarketing.smc_main(smc_id);
    PRINT '  - Created fk_smc_unique_value_proposition_smc_id_test';

    PRINT 'STEP 5: Completed - All foreign keys recreated';
    PRINT '';

    -- =============================================
    -- TRANSACTION COMPLETE
    -- =============================================
    PRINT '========================================';
    PRINT 'Migration Completed Successfully!';
    PRINT '========================================';
    PRINT '';
    PRINT 'Summary:';
    PRINT '  - 12 Foreign keys dropped and recreated';
    PRINT '  - 8 Tables renamed (ssc_* to smc_*)';
    PRINT '  - 12 Columns renamed (ssc_id/ssc_url to smc_id/smc_url)';
    PRINT '  - 1 Unique constraint renamed';
    PRINT '';
    PRINT 'Database is now using SMC (Solution Marketing Canvas) terminology.';
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
PRINT 'Tables with SMC in name:';
SELECT name FROM sys.tables WHERE name LIKE '%smc%' ORDER BY name;
PRINT '';
PRINT 'Foreign keys with SMC in name:';
SELECT name FROM sys.foreign_keys WHERE name LIKE '%smc%' ORDER BY name;
PRINT '';
PRINT 'Any remaining SSC references (should be empty):';
SELECT name FROM sys.tables WHERE name LIKE '%ssc%' ORDER BY name;
SELECT name FROM sys.foreign_keys WHERE name LIKE '%ssc%' ORDER BY name;
PRINT '';

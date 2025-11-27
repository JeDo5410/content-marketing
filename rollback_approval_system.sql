-- =============================================
-- ROLLBACK SCRIPT: Remove Approval System
-- Description: Reverts all approval system changes
-- Date: 2025-11-24
-- WARNING: This will remove all approval data!
-- =============================================

USE test_ssctosmc;
GO

PRINT '===== STARTING APPROVAL SYSTEM ROLLBACK =====';
PRINT 'WARNING: This will remove all approval data!';
PRINT '';

-- =============================================
-- STEP 1: Drop foreign key constraints
-- =============================================
PRINT 'STEP 1: Dropping foreign key constraints...';

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_content_asset_result_approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.content_asset_result
    DROP CONSTRAINT fk_content_asset_result_approved_by;
    PRINT '  - Dropped fk_content_asset_result_approved_by';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_smc_funnel_mapping_approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.smc_funnel_mapping
    DROP CONSTRAINT fk_smc_funnel_mapping_approved_by;
    PRINT '  - Dropped fk_smc_funnel_mapping_approved_by';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_smc_main_approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.smc_main
    DROP CONSTRAINT fk_smc_main_approved_by;
    PRINT '  - Dropped fk_smc_main_approved_by';
END

PRINT 'Foreign key constraints dropped successfully';
PRINT '';

-- =============================================
-- STEP 2: Drop indexes from content_asset_result
-- =============================================
PRINT 'STEP 2: Dropping indexes from content_asset_result...';

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_content_asset_result_approved_by')
BEGIN
    DROP INDEX idx_content_asset_result_approved_by ON test_contentmarketing.content_asset_result;
    PRINT '  - Dropped idx_content_asset_result_approved_by';
END

PRINT 'Indexes dropped from content_asset_result successfully';
PRINT '';

-- =============================================
-- STEP 3: Drop indexes from smc_funnel_mapping
-- =============================================
PRINT 'STEP 3: Dropping indexes from smc_funnel_mapping...';

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_smc_funnel_mapping_approved_by')
BEGIN
    DROP INDEX idx_smc_funnel_mapping_approved_by ON test_contentmarketing.smc_funnel_mapping;
    PRINT '  - Dropped idx_smc_funnel_mapping_approved_by';
END

PRINT 'Indexes dropped from smc_funnel_mapping successfully';
PRINT '';

-- =============================================
-- STEP 4: Drop indexes from smc_main
-- =============================================
PRINT 'STEP 4: Dropping indexes from smc_main...';

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_smc_main_approved_by')
BEGIN
    DROP INDEX idx_smc_main_approved_by ON test_contentmarketing.smc_main;
    PRINT '  - Dropped idx_smc_main_approved_by';
END

PRINT 'Indexes dropped from smc_main successfully';
PRINT '';

-- =============================================
-- STEP 5: Remove columns from content_asset_result
-- =============================================
PRINT 'STEP 5: Removing approval columns from content_asset_result...';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.content_asset_result') AND name = 'approval_comments')
BEGIN
    ALTER TABLE test_contentmarketing.content_asset_result
    DROP COLUMN approval_comments;
    PRINT '  - Dropped approval_comments';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.content_asset_result') AND name = 'approved_at')
BEGIN
    ALTER TABLE test_contentmarketing.content_asset_result
    DROP COLUMN approved_at;
    PRINT '  - Dropped approved_at';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.content_asset_result') AND name = 'approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.content_asset_result
    DROP COLUMN approved_by;
    PRINT '  - Dropped approved_by';
END

PRINT 'Approval columns removed from content_asset_result successfully';
PRINT '';

-- =============================================
-- STEP 6: Remove columns from smc_funnel_mapping
-- =============================================
PRINT 'STEP 6: Removing approval columns from smc_funnel_mapping...';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_funnel_mapping') AND name = 'approval_comments')
BEGIN
    ALTER TABLE test_contentmarketing.smc_funnel_mapping
    DROP COLUMN approval_comments;
    PRINT '  - Dropped approval_comments';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_funnel_mapping') AND name = 'approved_at')
BEGIN
    ALTER TABLE test_contentmarketing.smc_funnel_mapping
    DROP COLUMN approved_at;
    PRINT '  - Dropped approved_at';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_funnel_mapping') AND name = 'approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.smc_funnel_mapping
    DROP COLUMN approved_by;
    PRINT '  - Dropped approved_by';
END

PRINT 'Approval columns removed from smc_funnel_mapping successfully';
PRINT '';

-- =============================================
-- STEP 7: Remove columns from smc_main
-- =============================================
PRINT 'STEP 7: Removing approval columns from smc_main...';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_main') AND name = 'approval_comments')
BEGIN
    ALTER TABLE test_contentmarketing.smc_main
    DROP COLUMN approval_comments;
    PRINT '  - Dropped approval_comments';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_main') AND name = 'approved_at')
BEGIN
    ALTER TABLE test_contentmarketing.smc_main
    DROP COLUMN approved_at;
    PRINT '  - Dropped approved_at';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('test_contentmarketing.smc_main') AND name = 'approved_by')
BEGIN
    ALTER TABLE test_contentmarketing.smc_main
    DROP COLUMN approved_by;
    PRINT '  - Dropped approved_by';
END

PRINT 'Approval columns removed from smc_main successfully';
PRINT '';

-- =============================================
-- STEP 8: Drop approver_master table
-- =============================================
PRINT 'STEP 8: Dropping approver_master table...';

IF EXISTS (SELECT * FROM sys.tables WHERE schema_id = SCHEMA_ID('test_contentmarketing') AND name = 'approver_master')
BEGIN
    DROP TABLE test_contentmarketing.approver_master;
    PRINT 'approver_master table dropped successfully';
END
ELSE
BEGIN
    PRINT 'approver_master table does not exist';
END

PRINT '';

-- =============================================
-- ROLLBACK COMPLETE
-- =============================================
PRINT '===== APPROVAL SYSTEM ROLLBACK COMPLETED SUCCESSFULLY =====';
PRINT '';
PRINT 'All approval system changes have been removed.';
GO

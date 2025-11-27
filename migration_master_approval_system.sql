-- =============================================
-- MASTER MIGRATION: Complete Approval System Implementation
-- Description: Runs all approval system migrations in correct order
-- Date: 2025-11-24
-- =============================================
--
-- This script includes:
-- 1. Create approver_master table
-- 2. Add approval columns to smc_main
-- 3. Add approval columns to smc_funnel_mapping
-- 4. Add approval columns to content_asset_result
-- 5. Create foreign key constraints
--
-- =============================================

USE test_ssctosmc;
GO

PRINT '===== STARTING APPROVAL SYSTEM MIGRATION =====';
PRINT '';

-- =============================================
-- STEP 1: Create approver_master table
-- =============================================
PRINT 'STEP 1: Creating approver_master table...';

CREATE TABLE test_contentmarketing.approver_master (
    approver_id INT IDENTITY(1,1) NOT NULL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role_abbreviation VARCHAR(10) NOT NULL,
    approval_order INT NOT NULL,
    approval_label VARCHAR(50) NOT NULL,
    -- Computed column for dropdown display: "Name - Role - Label"
    display_name AS (name + ' - ' + role_abbreviation + ' - ' + approval_label) PERSISTED,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    created_by VARCHAR(150) NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(150) NULL,

    CONSTRAINT PK_approver_master PRIMARY KEY (approver_id),
    CONSTRAINT unique_approver_email UNIQUE (email),
    CONSTRAINT unique_approval_order UNIQUE (approval_order),
    CONSTRAINT check_approver_status CHECK (status IN ('active', 'inactive'))
);

CREATE NONCLUSTERED INDEX idx_approver_status
ON test_contentmarketing.approver_master(status);

CREATE NONCLUSTERED INDEX idx_approval_order
ON test_contentmarketing.approver_master(approval_order);

PRINT 'approver_master table created successfully';
PRINT '';

-- =============================================
-- STEP 2: Add approval columns to smc_main
-- =============================================
PRINT 'STEP 2: Adding approval columns to smc_main...';

ALTER TABLE test_contentmarketing.smc_main
ADD
    approved_by INT NULL,
    approved_at DATETIME2 NULL,
    approval_comments NVARCHAR(500) NULL;

CREATE NONCLUSTERED INDEX idx_smc_main_approved_by
ON test_contentmarketing.smc_main(approved_by);

PRINT 'Approval columns added to smc_main successfully';
PRINT '';

-- =============================================
-- STEP 3: Add approval columns to smc_funnel_mapping
-- =============================================
PRINT 'STEP 3: Adding approval columns to smc_funnel_mapping...';

ALTER TABLE test_contentmarketing.smc_funnel_mapping
ADD
    approved_by INT NULL,
    approved_at DATETIME2 NULL,
    approval_comments NVARCHAR(500) NULL;

CREATE NONCLUSTERED INDEX idx_smc_funnel_mapping_approved_by
ON test_contentmarketing.smc_funnel_mapping(approved_by);

PRINT 'Approval columns added to smc_funnel_mapping successfully';
PRINT '';

-- =============================================
-- STEP 4: Add approval columns to content_asset_result
-- =============================================
PRINT 'STEP 4: Adding approval columns to content_asset_result...';

ALTER TABLE test_contentmarketing.content_asset_result
ADD
    approved_by INT NULL,
    approved_at DATETIME2 NULL,
    approval_comments NVARCHAR(500) NULL;

CREATE NONCLUSTERED INDEX idx_content_asset_result_approved_by
ON test_contentmarketing.content_asset_result(approved_by);

PRINT 'Approval columns added to content_asset_result successfully';
PRINT '';

-- =============================================
-- STEP 5: Create foreign key constraints
-- =============================================
PRINT 'STEP 5: Creating foreign key constraints...';

ALTER TABLE test_contentmarketing.smc_main
ADD CONSTRAINT fk_smc_main_approved_by
FOREIGN KEY (approved_by)
REFERENCES test_contentmarketing.approver_master(approver_id);

ALTER TABLE test_contentmarketing.smc_funnel_mapping
ADD CONSTRAINT fk_smc_funnel_mapping_approved_by
FOREIGN KEY (approved_by)
REFERENCES test_contentmarketing.approver_master(approver_id);

ALTER TABLE test_contentmarketing.content_asset_result
ADD CONSTRAINT fk_content_asset_result_approved_by
FOREIGN KEY (approved_by)
REFERENCES test_contentmarketing.approver_master(approver_id);

PRINT 'All foreign key constraints created successfully';
PRINT '';

-- =============================================
-- MIGRATION COMPLETE
-- =============================================
PRINT '===== APPROVAL SYSTEM MIGRATION COMPLETED SUCCESSFULLY =====';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Run the sample data script to populate approvers';
PRINT '2. Update your application to use the display_name column for dropdowns';
PRINT '3. Query: SELECT approver_id, display_name FROM approver_master WHERE status = ''active'' ORDER BY approval_order';
GO

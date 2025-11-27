-- =============================================
-- Sample Data: Insert sample approvers into approver_master
-- Description: Example data showing how to populate approvers
-- Date: 2025-11-24
-- =============================================

USE test_ssctosmc;
GO

PRINT 'Inserting sample approvers...';
PRINT '';

-- Insert sample approvers based on the user's example
INSERT INTO test_contentmarketing.approver_master
    (name, email, role_abbreviation, approval_order, approval_label, status, created_by)
VALUES
    ('Dewi Sofiana', 'dewi.sofiana@company.com', 'CMP', 1, '1st approver', 'active', 'SYSTEM'),
    ('Natania Shareen', 'natania.shareen@company.com', 'CMM', 2, '2nd approver', 'active', 'SYSTEM'),
    ('Dannica', 'dannica@company.com', 'CL', 3, 'Final Approver', 'active', 'SYSTEM');
GO

PRINT 'Sample approvers inserted successfully';
PRINT '';

-- Display the results showing the computed display_name column
PRINT 'Showing all active approvers (as they would appear in dropdown):';
PRINT '';

SELECT
    approver_id,
    display_name,
    email,
    status,
    approval_order
FROM test_contentmarketing.approver_master
WHERE status = 'active'
ORDER BY approval_order;
GO

PRINT '';
PRINT '===== USAGE EXAMPLES =====';
PRINT '';
PRINT '1. Get approvers for dropdown:';
PRINT '   SELECT approver_id, display_name FROM approver_master WHERE status = ''active'' ORDER BY approval_order';
PRINT '';
PRINT '2. Record an approval for smc_main:';
PRINT '   UPDATE smc_main SET approved_by = 1, approved_at = SYSUTCDATETIME(), approval_comments = ''Approved'', status = ''approved'' WHERE smc_id = ''SMC-001''';
PRINT '';
PRINT '3. Get approval details with approver name:';
PRINT '   SELECT s.smc_id, s.status, a.display_name as approver, s.approved_at, s.approval_comments';
PRINT '   FROM smc_main s';
PRINT '   LEFT JOIN approver_master a ON s.approved_by = a.approver_id';
PRINT '';
GO

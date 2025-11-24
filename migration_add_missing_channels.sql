-- =============================================
-- Migration Script: Add Missing Channels
-- Description: Add WhatsApp, LinkedIn Message, and HubSpot Email channels
-- Date: 2025-11-17
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Adding Missing Channels';
    PRINT '========================================';
    PRINT '';

    -- Add WhatsApp
    IF NOT EXISTS (SELECT * FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'WA')
    BEGIN
        INSERT INTO test_contentmarketing.contentmarketing_channels_master
            (channel_name, channel_code, description, status, created_at)
        VALUES
            ('WhatsApp', 'WA', 'WhatsApp messaging channel', 'active', GETDATE());
        PRINT '  - Added WhatsApp channel';
    END
    ELSE
        PRINT '  - WhatsApp channel already exists';

    -- Add LinkedIn Message (different from LinkedIn Ads)
    IF NOT EXISTS (SELECT * FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'LI_MSG')
    BEGIN
        INSERT INTO test_contentmarketing.contentmarketing_channels_master
            (channel_name, channel_code, description, status, created_at)
        VALUES
            ('LinkedIn Message', 'LI_MSG', 'LinkedIn direct messaging', 'active', GETDATE());
        PRINT '  - Added LinkedIn Message channel';
    END
    ELSE
        PRINT '  - LinkedIn Message channel already exists';

    -- Add HubSpot Email / Database Email
    IF NOT EXISTS (SELECT * FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'HS_EMAIL')
    BEGIN
        INSERT INTO test_contentmarketing.contentmarketing_channels_master
            (channel_name, channel_code, description, status, created_at)
        VALUES
            ('HubSpot Email', 'HS_EMAIL', 'Database email via HubSpot', 'active', GETDATE());
        PRINT '  - Added HubSpot Email channel';
    END
    ELSE
        PRINT '  - HubSpot Email channel already exists';

    PRINT '';
    PRINT 'Migration completed successfully!';

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

GO

-- Verify new channels
PRINT '';
PRINT 'All channels in database:';
SELECT channel_id, channel_code, channel_name, status
FROM test_contentmarketing.contentmarketing_channels_master
ORDER BY channel_id;

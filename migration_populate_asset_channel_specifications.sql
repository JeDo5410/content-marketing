-- =============================================
-- Migration Script: Populate Asset Channel Specifications
-- Description: Insert all specifications from Canva Guide Template Library
-- Date: 2025-11-17
-- =============================================
-- PREREQUISITES:
--   1. Run migration_add_missing_channels.sql first
--   2. Run migration_fix_unique_constraint_for_null_channel.sql second
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    PRINT '========================================';
    PRINT 'Populating Asset Channel Specifications';
    PRINT '========================================';
    PRINT '';

    -- Get channel IDs for new channels
    DECLARE @HS_EMAIL_ID INT, @WA_ID INT, @LI_MSG_ID INT;
    SELECT @HS_EMAIL_ID = channel_id FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'HS_EMAIL';
    SELECT @WA_ID = channel_id FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'WA';
    SELECT @LI_MSG_ID = channel_id FROM test_contentmarketing.contentmarketing_channels_master WHERE channel_code = 'LI_MSG';

    PRINT 'Channel IDs:';
    PRINT '  - HubSpot Email: ' + CAST(@HS_EMAIL_ID AS VARCHAR);
    PRINT '  - WhatsApp: ' + CAST(@WA_ID AS VARCHAR);
    PRINT '  - LinkedIn Message: ' + CAST(@LI_MSG_ID AS VARCHAR);
    PRINT '';

    -- =============================================
    -- EMAIL SPECIFICATIONS (3 channels)
    -- =============================================
    PRINT 'Inserting Email specifications...';

    -- 1. Email - HubSpot
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         cta_word_count_min, cta_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (40, @HS_EMAIL_ID, 9, 13, 27, 34, 120, 140, 3, 5,
         '~80 chars for headline, ~220 chars for sub-headline', 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Email (HubSpot)';

    -- 2. Email - WhatsApp
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (40, @WA_ID, 4, 7, 6, 10, 50, 80,
         '~30–55 chars for headline, ~45–80 chars for sub-headline, ~350–550 chars for body',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Email (WhatsApp)';

    -- 3. Email - LinkedIn Message
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (40, @LI_MSG_ID, 8, 12, 10, 15, 80, 120,
         '~60–90 chars for headline, ~75–120 chars for sub-headline, ~550–850 chars for body',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Email (LinkedIn Message)';

    -- =============================================
    -- SOLUTION BROCHURE (No specific channel)
    -- =============================================
    PRINT 'Inserting Solution Brochure specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format, paper_size,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         cta_word_count_min, cta_word_count_max,
         status, created_at, created_by)
    VALUES
        (31, NULL, 'PDF', 'A4 (210 × 297 mm)',
         6, 10, 15, 20, 120, 140, 3, 5,
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Brochure';

    -- =============================================
    -- SOLUTION LANDING PAGE
    -- =============================================
    PRINT 'Inserting Solution Landing Page specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         cta_word_count_min, cta_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (29, NULL, 10, 12, 20, 25, 40, 60, 3, 5,
         '~70 chars for headline, ~120 chars for sub-headline, per paragraph for body',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Landing Page';

    -- =============================================
    -- SOLUTION VIDEO SCRIPT
    -- =============================================
    PRINT 'Inserting Solution Video Script specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format,
         cta_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (26, NULL, 'PDF/Word', 10,
         '~150 words per minute', 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Video Script';

    -- =============================================
    -- SOLUTION VIDEO PRODUCTION
    -- =============================================
    PRINT 'Inserting Solution Video Production specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, status, created_at, created_by)
    VALUES
        (44, NULL, 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Video Production (no specific specs)';

    -- =============================================
    -- SOLUTION ARTICLE
    -- =============================================
    PRINT 'Inserting Solution Article specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format, paper_size,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (30, NULL, 'PDF/Word', 'A4 (210 × 297 mm)',
         8, 12, 15, 20, 40, 60,
         '4–6 pages, paragraphs 40–60 words', 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Article';

    -- =============================================
    -- SOLUTION BANNER ADVERT (5 channels)
    -- =============================================
    PRINT 'Inserting Solution Banner Advert specifications...';

    -- Banner - TikTok
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format,
         duration_min, duration_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (25, 4, 'Video', '30s', '50s', 130, 150,
         '1080x1920 px, 9:16 aspect ratio', 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Banner (TikTok)';

    -- Banner - YouTube
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format,
         duration_min, duration_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (25, 6, 'Video', '1 min', '3 mins', 420, 510,
         '1920x1080 px, 16:9 aspect ratio', 'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Banner (YouTube)';

    -- Banner - Facebook
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (25, 1, 5, 7, 10, 15,
         '1200x628 px, ~40 chars for headline, ~90 chars for sub-headline, Image text <20%',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Banner (Facebook)';

    -- Banner - LinkedIn
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (25, 3, 5, 7, 10, 15,
         '1080x1080 px, 1:1 aspect ratio, ~40 chars for headline, ~90 chars for sub-headline, Image text <20%',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Banner (LinkedIn)';

    -- Banner - Google Ads
    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (25, 5, 5, 7, 10, 15,
         '300x250 px, ~40 chars for headline, ~90 chars for sub-headline, Image text <20%',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Banner (Google Ads)';

    -- =============================================
    -- SOLUTION UVP PITCH
    -- =============================================
    PRINT 'Inserting Solution UVP Pitch specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (27, NULL, 6, 10, 10, 15,
         '1920x1080 px (HD), 16:9 aspect ratio, Bullet points: 5–7 words each, max 5 bullets',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution UVP Pitch';

    -- =============================================
    -- SOLUTION MINISITE
    -- =============================================
    PRINT 'Inserting Solution Minisite specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         cta_word_count_min, cta_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (33, NULL, 10, 12, 20, 25, 40, 60, 3, 5,
         'Responsive web (desktop 1440 px width, mobile 375 px), ~70 chars for headline, ~120 chars for sub-headline, per paragraph for body',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution Minisite';

    -- =============================================
    -- SOLUTION PPT
    -- =============================================
    PRINT 'Inserting Solution PPT specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (34, NULL, 6, 10, 10, 15,
         '16:9 widescreen (1920x1080 px), Bullet points: 5–7 words each, max 5 bullets',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Solution PPT';

    -- =============================================
    -- PRODUCT BROCHURE
    -- =============================================
    PRINT 'Inserting Product Brochure specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format, paper_size,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         cta_word_count_min, cta_word_count_max,
         status, created_at, created_by)
    VALUES
        (32, NULL, 'PDF', 'A4 (210 × 297 mm)',
         6, 10, 15, 20, 120, 140, 3, 5,
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Product Brochure';

    -- =============================================
    -- PODCAST
    -- =============================================
    PRINT 'Inserting Podcast specifications...';

    INSERT INTO test_contentmarketing.asset_channel_specification
        (asset_type_id, channel_id, file_format, audio_quality,
         headline_word_count_min, headline_word_count_max,
         subheadline_word_count_min, subheadline_word_count_max,
         body_word_count_min, body_word_count_max,
         additional_specs, status, created_at, created_by)
    VALUES
        (28, NULL, 'MP3', '44.1kHz',
         10, 12, 20, 25, 40, 60,
         '~70 chars for headline, ~120 chars for sub-headline, per paragraph for body',
         'active', SYSUTCDATETIME(), 'migration');
    PRINT '  - Podcast';

    -- =============================================
    -- TRANSACTION COMPLETE
    -- =============================================
    PRINT '';
    PRINT '========================================';
    PRINT 'Migration Completed Successfully!';
    PRINT '========================================';
    PRINT '';
    PRINT 'Summary:';
    PRINT '  - 18 asset-channel specifications inserted';
    PRINT '  - 3 Email channel variations';
    PRINT '  - 5 Solution Banner Advert channel variations';
    PRINT '  - 10 Generic asset specifications';
    PRINT '';

    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';

END TRY
BEGIN CATCH
    PRINT '';
    PRINT 'ERROR: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Transaction rolled back.';
    THROW;
END CATCH;

GO

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';
PRINT '';

SELECT
    spec_id,
    at.asset_name,
    cm.channel_name,
    file_format,
    paper_size,
    headline_word_count_min,
    headline_word_count_max,
    body_word_count_min,
    body_word_count_max,
    s.status
FROM test_contentmarketing.asset_channel_specification s
INNER JOIN test_contentmarketing.asset_type at ON s.asset_type_id = at.asset_type_id
LEFT JOIN test_contentmarketing.contentmarketing_channels_master cm ON s.channel_id = cm.channel_id
ORDER BY at.asset_name, cm.channel_name;

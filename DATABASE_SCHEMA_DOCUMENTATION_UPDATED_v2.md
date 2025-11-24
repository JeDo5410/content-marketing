# Data Structure: Agentic Content Marketer
## Updated Database Schema Documentation v2.0

---

## 📋 Document Information

| Field | Details |
|-------|---------|
| **Document Title** | Data Structure: Content Marketing Application Database Schema |
| **Document ID** | DOC-CLaaS-001 |
| **Current Version** | v2.0 |
| **Document Owner** | John Edward Oblepias |
| **Document Status** | Updated - Reflecting Current Schema |
| **Classification** | Internal / Confidential |
| **Last Updated** | November 2025 |

---

## 📝 Version History

| Version | Date | Author | Changes Made | Status |
|---------|------|--------|--------------|--------|
| v1.0 | 04/11/2025 | John Edward Oblepias | Initial database schema created for Content Marketing Application covering Stages 1-3 | Draft |
| v2.0 | 18/11/2025 | John Edward Oblepias | Major update: SSC→SMC terminology, removed UVP/segments/competition tables, replaced content_asset_builder with asset_channel_specification, renamed sub_solution to product | Updated |

---

## 🔄 Change Log v2.0

| Change ID | Section | Description of Change | Rationale |
|-----------|---------|----------------------|-----------|
| CH-001 | All | Renamed SSC (Solution Sales Canvas) to SMC (Solution Marketing Canvas) | Better reflects marketing-focused approach |
| CH-002 | All | Renamed "Sub Solution" to "Product" | Clearer business terminology |
| CH-003 | Stage 1 | Removed tables: ssc_unique_value_proposition, ssc_customer_segments, ssc_competition | Schema simplification and focus on core canvas elements |
| CH-004 | Stage 1 | Added product_id, pdf_url, png_url to smc_main | Enhanced export capabilities |
| CH-005 | Stage 3 | Removed content_asset_builder table | Replaced with more flexible specification system |
| CH-006 | Stage 3 | Added asset_channel_specification table | Centralized, reusable specification management with tool integration |
| CH-007 | Master Tables | Renamed contentmarketing_sub_solutions_master to contentmarketing_product_master | Aligned with product terminology |

---

## 📊 Summary of Database Changes

### Terminology Updates
- **SSC → SMC** (Solution Sales Canvas → Solution Marketing Canvas)
- **Sub Solution → Product**
- All table prefixes: `ssc_*` → `smc_*`

### Removed Tables (5)
1. ❌ `ssc_unique_value_proposition` - Simplified canvas structure
2. ❌ `ssc_customer_segments` - Consolidated into persona management
3. ❌ `ssc_competition` - Moved to external tools
4. ❌ `contentmarketing_sub_solutions_master` - Replaced
5. ❌ `content_asset_builder` - Replaced with new system

### Added Tables (2)
1. ✅ `asset_channel_specification` - Channel-specific asset specifications
2. ✅ `contentmarketing_product_master` - Product catalog (replaces sub_solutions)

### Modified Tables (11)
- `smc_main` - Added product_id, pdf_url, png_url
- `smc_problem_statements` - Renamed columns
- All `ssc_*` tables renamed to `smc_*`

### Current Table Count
**19 tables** in `test_contentmarketing` schema

---

# 📖 UPDATED DOCUMENTATION SECTIONS
*Each section below is ready to copy and paste into the original document*

---

## SECTION 1: Overview

### Copy this section to replace the Overview in original document

---

### Overview

This database schema documentation covers the complete data structure for the **Content Marketing Application (Agentic Marketer)** for CLaaS2SaaS. The system manages an end-to-end content marketing lifecycle from solution positioning through final asset deployment.

### Application Purpose

The Content Marketing Application automates and streamlines the creation, management, and deployment of marketing content across the CILOS funnel (Contact → Interest → Leads → Opportunity → Sales). It serves as a centralized platform for Content Marketing Associates (CMAs) to:

1. Define solution positioning via **Solution Marketing Canvas (SMC)**
2. Map content strategy across marketing funnel stages
3. Generate AI-assisted marketing assets with channel-specific specifications
4. Create and version content using integrated design tools
5. Package and deploy approved content

### Database Architecture Philosophy

The schema follows a **stage-based workflow design** with three primary stages:

- **Stage 1:** Solution Marketing Canvas (SMC) Foundation - Strategic positioning and validation
- **Stage 2:** Content Strategy & Funnel Mapping - AI-assisted content planning
- **Stage 3:** Asset Specification & Content Workflow - Channel-specific requirements and AI-powered asset creation

Each stage maintains referential integrity through foreign key relationships, ensuring data consistency and traceability throughout the content lifecycle.

---

## SECTION 2: Stage 1 - Solution Marketing Canvas (SMC) Foundation

### Copy this section to replace Stage 1 in original document

---

## Schema: test_contentmarketing

## Stage 1: Solution Marketing Canvas (SMC) Foundation

This stage captures the core business positioning data that serves as the single source of truth for all downstream content creation activities.

### Table: smc_main

Central table storing Solution Marketing Canvas records with solution/product configuration, approval workflow tracking, and creator attribution.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| smc_id | varchar(255) | Primary key, unique SMC identifier | PRIMARY KEY |
| solution_id | int | Foreign key to solution master | FOREIGN KEY (contentmarketing_solution_master.solution_id), NOT NULL |
| product_id | int | Foreign key to product master | NOT NULL |
| smc_url | varchar(500) | Link to generated SMC canvas document/file | NULL allowed |
| created_date | datetime2 | Timestamp of SMC creation | NOT NULL, DEFAULT GETDATE() |
| created_by | varchar(255) | User who created this SMC | NOT NULL |
| status | varchar(20) | Approval workflow status | NOT NULL, CHECK: 'Draft', 'In-Review', 'Approved', 'Rejected', DEFAULT 'In-Review' |
| pdf_url | varchar(500) | URL to PDF export of SMC | NULL allowed |
| png_url | varchar(500) | URL to PNG/image export of SMC | NULL allowed |

**Business Rules:**
- Each SMC must link to valid solution and product combinations
- Only users who are Admin/Owner can approve SMCs
- Status transitions: Draft → In-Review → Approved/Rejected
- Approved SMCs become read-only and will be used for Stage 2
- PDF and PNG URLs are populated upon SMC finalization for sharing and archival

### Table: smc_channels

Marketing channels associated with each SMC (max 4 per SMC as per business rules).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| channel_id | int | Foreign key to channel master | FOREIGN KEY (contentmarketing_channels_master.channel_id), NOT NULL |
| channel_order | int | Sequential order of channel (1-4) | NOT NULL |

**Unique Constraint:** UNIQUE (smc_id, channel_order)

**Business Rules:**
- Maximum 4 channels per SMC
- channel_order determines display sequence (1 = first choice, 2 = second, etc.)
- Channel categories: ① Social Media ② Direct Sales ③ Offline ④ Alliances

### Table: smc_personas

Buyer personas linked to each SMC (minimum 1 required per business rules).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| persona_value | varchar(255) | Persona name/description | NOT NULL |
| persona_order | int | Sequential order | NOT NULL |

**Unique Constraint:** UNIQUE (smc_id, persona_order)

**Business Rules:**
- Minimum 1 persona required per SMC
- Personas are used in Stage 2 for content mapping across CILOS funnel
- Persona names example: "Fresh graduate", "Early career adult"

### Table: smc_problem_statements

Problems that the solution addresses (max 3-4 per business rules).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| statement_value | varchar(255) | Description of customer pain point | NOT NULL |
| statement_order | int | Sequential order (1-4) | NOT NULL |

**Unique Constraint:** UNIQUE (smc_id, statement_order)

**Business Rules:**
- Maximum 3-4 problem statements per SMC
- Problems must tie to chosen customer segments
- Used to generate problem-focused content topics in Stage 2

### Table: smc_solution_features

Key differentiating features of the solution (max 3 per business rules).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| feature_value | varchar(255) | Feature name and description | NOT NULL |
| feature_order | int | Sequential order (1-3) | NOT NULL |

**Unique Constraint:** UNIQUE (smc_id, feature_order)

**Business Rules:**
- Maximum 3 solution features per SMC
- Features must align with value propositions
- Feature descriptions limited to 255 characters

### Table: smc_unfair_advantage

Unique competitive advantages at company/solution level (max 3 per business rules).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| advantage_value | varchar(255) | Description of unfair advantage | NOT NULL |
| advantage_order | int | Sequential order (1-3) | NOT NULL |

**Unique Constraint:** UNIQUE (smc_id, advantage_order)

**Business Rules:**
- Maximum 3 unfair advantages per SMC
- Examples: "SkillsFuture SG partnership", "Digital acceleration platform"
- Used to inform differentiation messaging in campaigns

### Master Table: contentmarketing_solution_master

Catalog of all CLaaS2SaaS solutions.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| solution_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| solution_name | varchar(255) | Solution name | NOT NULL |
| solution_code | varchar(255) | Short code for solution | - |
| description | varchar(500) | Solution description | NULL allowed |
| status | varchar(8) | Active status | NOT NULL, CHECK: 'Active', 'Inactive' |
| created_at | datetime | Record creation timestamp | NOT NULL, DEFAULT GETDATE() |

**Predefined Values:**
- HED CLaaS (Higher Education CLaaS)
- Lifelong CET CLaaS (Continuing Education & Training)
- Enterprise CLaaS
- University Alliance

### Master Table: contentmarketing_product_master

Products under each primary solution (formerly sub-solutions).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| product_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| solution_id | int | Foreign key to parent solution | FOREIGN KEY (contentmarketing_solution_master.solution_id), NOT NULL |
| product_name | varchar(255) | Product name | NOT NULL |
| product_code | varchar(255) | Short code | - |
| description | varchar(500) | Product description | NULL allowed |
| status | varchar(8) | Active status | NOT NULL, CHECK: 'Active', 'Inactive' |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT GETDATE() |

**Example Products:**
- HED CLaaS → {WSD DB, WSD SE, WIM SE, WIM DB}
- Lifelong CET CLaaS → {LLL DM, LLL CC, LLL DSAI, LLL AI APPS, LLL DIL}
- Enterprise CLaaS → {SME Digitalization CLaaS, Large Corporate CLaaS}
- University Alliance → {University Alliance}

### Master Table: contentmarketing_channels_master

Marketing channel definitions.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| channel_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| channel_name | varchar(100) | Channel name | NOT NULL |
| channel_code | varchar(100) | Short code for channel | NOT NULL |
| description | varchar(500) | Channel description | NULL allowed |
| status | varchar(8) | Active status | NOT NULL, CHECK: 'Active', 'Inactive' |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT GETDATE() |

**Predefined Channels:**
- **Social Media:** Facebook, Instagram, LinkedIn, TikTok, YouTube
- **Direct Sales:** Direct Sales Team, Inside Sales
- **Offline:** Events, Proposals, Demos, Conferences
- **Alliances:** Partner Networks, Resellers

---

## SECTION 3: Stage 2 - Content Strategy & Funnel Mapping

### Copy this section to replace Stage 2 in original document

---

## Stage 2: Content Strategy & Funnel Mapping

This stage handles AI-generated content strategy, mapping personas across the CILOS funnel with appropriate channels, topics, CTAs, and asset types.

### Table: asset_type

Content asset types available for marketing campaigns.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| asset_type_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| asset_code | varchar(50) | Short code for asset type | NOT NULL |
| asset_name | varchar(150) | Asset type name | NOT NULL |

**Asset Types by CILOS Stage:**
- **Contact (C):** Solution Banner Advert, Solution Video Script, Solution UVP Pitch, Podcast
- **Interest (I):** Solution Landing Page, Solution Article, Solution Brochure, Product Brochure
- **Leads (L):** Solution Minisite, Solution PPT, Solution Video Production
- **Opportunity (O):** Solution PPT
- **Sales (S):** Solution Article (Case Study or Success Story), Product Brochure (Enrollment Info Sheet)

### Table: cilos_stage

Learning outcome stages in the marketing funnel.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| cilos_stage_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| cilos_code | varchar(10) | Single letter code | NOT NULL |
| cilos_name | varchar(100) | Full stage name | NOT NULL |

**CILOS Stages:**
- **C (Contact):** Initial awareness and reach
- **I (Interest):** Engagement and education
- **L (Leads):** Lead generation and nurturing
- **O (Opportunity):** Sales qualification
- **S (Sales):** Closing and enrollment

### Table: funnel_stage

Marketing funnel stage definitions.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| funnel_stage_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| funnel_code | varchar(50) | Short code for stage | NOT NULL |
| funnel_name | varchar(100) | Stage name | NOT NULL |

**Funnel Stages:**
- Awareness
- Interest
- Consideration
- Decision
- Won/Enrollment

### Table: content_topic

AI-generated content topics based on SMC data (editable by users).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| content_topic_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| content_topic | varchar(500) | Topic description | NOT NULL |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT SYSUTCDATETIME() |

**Business Rules:**
- AI generates topics from SMC problems, features, and competitive advantages
- Topics are editable by CMAs
- Maximum 500 characters per topic
- Topics must be relevant to associated CILOS/funnel stage

### Table: cta

Call-to-action library (AI-selected by stage, editable by users).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| cta_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| cta_text | varchar(500) | CTA text | NOT NULL |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT SYSUTCDATETIME() |

**Example CTAs by Stage:**
- **Contact:** "Visit landing page", "Learn more"
- **Interest:** "Read the brief", "Watch the video", "Explore minisite"
- **Leads:** "Get the guide", "Download brochure", "Subscribe"
- **Opportunity:** "Book a live demo", "Request consultation"
- **Sales:** "Approve proposal", "Enroll now"

### Table: smc_funnel_mapping

Links all Stage 2 components together for complete full-funnel content planning.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| funnel_mapping_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| smc_id | varchar(255) | Foreign key to parent SMC | FOREIGN KEY (smc_main.smc_id), NOT NULL |
| pdf_url | varchar(1000) | URL to PDF export | NULL allowed |
| word_url | varchar(1000) | URL to Word export | NULL allowed |
| funnel_stage_id | int | Foreign key to funnel stage | FOREIGN KEY (funnel_stage.funnel_stage_id), NOT NULL |
| cilos_stage_id | int | Foreign key to CILOS stage | FOREIGN KEY (cilos_stage.cilos_stage_id), NOT NULL |
| asset_type_id | int | Foreign key to asset type | FOREIGN KEY (asset_type.asset_type_id), NOT NULL |
| content_topic_id | int | Foreign key to content topic | FOREIGN KEY (content_topic.content_topic_id), NOT NULL |
| cta_id | int | Foreign key to CTA | FOREIGN KEY (cta.cta_id), NOT NULL |
| sort_order | int | Display order | NULL allowed |
| status | varchar(20) | Approval workflow status | NOT NULL, CHECK: 'Draft', 'In-Review', 'Approved', 'Rejected', DEFAULT 'In-Review' |
| remarks | varchar(300) | Additional notes/comments | NULL allowed |
| created_by | varchar(150) | CMA who created mapping | NULL allowed |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT SYSUTCDATETIME() |
| updated_at | datetime2 | Last update timestamp | NULL allowed |

**Business Rules:**
- Each mapping row represents one content asset to be created
- All AI suggestions (asset type, topic, CTA) are editable
- Status transitions: Draft → In-Review → Approved/Rejected
- Approved mappings are read-only and passed to Stage 3

---

## SECTION 4: Stage 3 - Asset Specification & Content Workflow

### Copy this section to replace Stage 3 in original document

---

## Stage 3: Asset Specification & Content Workflow

This stage manages channel-specific asset specifications and AI-powered content creation with version control and final asset export.

### Reference Table: brand_guideline_ref

Brand guideline references (read-only for users, managed by admin).

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| guideline_id | int | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| title | varchar(200) | Guideline document name | NOT NULL |
| guideline_url | varchar(1000) | URL to brand guideline PDF | NOT NULL |

**Business Rules:**
- One-time setup by admin
- Read-only for CMAs during content creation
- Ensures style consistency across all assets
- Reference: eduCLaaS Brand Guidelines (May 2024)

### Table: asset_channel_specification

Defines technical specifications for each asset type per marketing channel, ensuring AI-generated and final assets meet channel requirements.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| spec_id | bigint | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| asset_type_id | int | Foreign key to asset type | FOREIGN KEY (asset_type.asset_type_id), NOT NULL |
| channel_id | int | Foreign key to channel (nullable for general specs) | FOREIGN KEY (contentmarketing_channels_master.channel_id), NULL allowed |
| file_format | varchar(50) | Required file format (e.g., MP4, PDF, PNG) | NULL allowed |
| paper_size | varchar(100) | Paper/canvas size (e.g., A4, Letter, Custom) | NULL allowed |
| audio_quality | varchar(50) | Audio quality specification | NULL allowed |
| duration_min | varchar(20) | Minimum duration for video/audio | NULL allowed |
| duration_max | varchar(20) | Maximum duration for video/audio | NULL allowed |
| headline_word_count_min | int | Minimum headline word count | NULL allowed |
| headline_word_count_max | int | Maximum headline word count | NULL allowed |
| subheadline_word_count_min | int | Minimum subheadline word count | NULL allowed |
| subheadline_word_count_max | int | Maximum subheadline word count | NULL allowed |
| body_word_count_min | int | Minimum body word count | NULL allowed |
| body_word_count_max | int | Maximum body word count | NULL allowed |
| cta_word_count_min | int | Minimum CTA word count | NULL allowed |
| cta_word_count_max | int | Maximum CTA word count | NULL allowed |
| additional_specs | nvarchar(max) | JSON or text for additional specifications | NULL allowed |
| status | varchar(20) | Active status | NOT NULL, DEFAULT 'active' |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT SYSUTCDATETIME() |
| created_by | varchar(150) | Admin who created spec | NULL allowed |
| updated_at | datetime2 | Last update timestamp | NULL allowed |
| updated_by | varchar(150) | Admin who last updated spec | NULL allowed |
| tool_url | varchar(500) | URL to design tool (e.g., Canva template) | NULL allowed |
| tool_button_text | varchar(100) | Button text for tool link | NULL allowed |
| tool_url_2 | varchar(500) | URL to secondary tool | NULL allowed |
| tool_button_text_2 | varchar(100) | Button text for secondary tool | NULL allowed |

**Business Rules:**
- One specification can apply to multiple asset/channel combinations
- channel_id can be NULL for general asset type specifications
- Specifications guide both AI content generation and manual asset creation
- All specification fields are optional but recommended for quality control
- Tool URLs link to external platforms (Canva, CapCut, etc.) for asset creation
- Supports up to 2 tool integrations per specification
- additional_specs allows flexible JSON structure for custom requirements

**Example Specifications:**

| Asset Type | Channel | File Format | Word Count Ranges | Duration | Tools |
|------------|---------|-------------|-------------------|----------|-------|
| Video Script | TikTok | MP4 | Headline: 10-15 words | 15-60 sec | Canva, CapCut |
| Banner Ad | LinkedIn | PNG/JPG | Headline: 5-10, Body: 100-150 | - | Canva |
| Landing Page | Web | HTML | Headline: 8-12, Body: 40-60/section | - | Custom |
| Email | Email | HTML | Subject: 6-8, Body: 50-60/para | - | MailChimp |

### Workflow Table: content_asset_result

Versioned AI-generated results with parent-child chain for version tracking.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| result_id | bigint | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| builder_id | bigint | Foreign key to builder session | NOT NULL |
| version_no | int | Sequential version number | NOT NULL |
| is_current | bit | Flag indicating current/active version | NOT NULL, DEFAULT 1 |
| parent_result_id | bigint | Foreign key to previous version | FOREIGN KEY (content_asset_result.result_id), NULL allowed |
| user_prompt | nvarchar(max) | User's input prompt/instructions | NOT NULL |
| ai_output_text | nvarchar(max) | AI-generated text content | NOT NULL |
| word_count | int | Total word count of AI output | NULL allowed |
| pdf_url | varchar(1000) | URL to exported PDF file | NULL allowed |
| word_url | varchar(1000) | URL to exported Word file | NULL allowed |

**Business Rules:**
- Each result is versioned with parent-child relationship for full audit trail
- version_no increments automatically within a builder_id (1, 2, 3, …)
- AI regeneration creates new result with previous result as parent
- Only one result can have is_current = 1 per builder_id
- user_prompt captures user's instructions for this generation
- ai_output_text stores the complete generated content
- pdf_url and word_url populated after content approval and export

**Version Control Examples:**
- **Initial Generation:** result_id=1, version_no=1, parent_result_id=NULL, is_current=1
- **Regeneration:** result_id=2, version_no=2, parent_result_id=1, is_current=1 (result_id=1 now has is_current=0)
- **Polish/Edit:** result_id=3, version_no=3, parent_result_id=2, is_current=1

### Table: content_asset_final

Final marketing assets created by the Content Marketing team using third-party applications (Canva, CapCut, etc.) with approval workflow tracking.

| Column Name | Data Type | Description | Constraints |
|------------|-----------|-------------|-------------|
| final_asset_id | bigint | Primary key | PRIMARY KEY, IDENTITY(1,1) |
| funnel_mapping_id | int | Foreign key to Stage 2 funnel mapping | FOREIGN KEY (smc_funnel_mapping.funnel_mapping_id), NOT NULL |
| asset_url | varchar(1000) | SharePoint link to final asset file | NOT NULL |
| folder_name | varchar(255) | SharePoint folder name (follows SMC-ID naming convention) | NOT NULL |
| third_party_app | varchar(100) | Application used to create asset (e.g., Canva, CapCut) | NULL allowed |
| status | varchar(20) | Approval workflow status | NOT NULL, CHECK: 'Draft', 'In-Review', 'Approved', 'Rejected', DEFAULT 'Draft' |
| remarks | varchar(300) | Additional notes/comments | NULL allowed |
| created_by | varchar(150) | CMA who uploaded the asset | NULL allowed |
| created_at | datetime2 | Record creation timestamp | NOT NULL, DEFAULT SYSUTCDATETIME() |
| updated_by | varchar(150) | User who last updated the record | NULL allowed |
| updated_at | datetime2 | Last update timestamp | NULL allowed |
| version_no | int | Version number for tracking asset iterations | NOT NULL, DEFAULT 1 |

**Business Rules:**
- Each final asset links to approved Stage 2 funnel mapping via funnel_mapping_id
- asset_url stores the complete SharePoint link to the finalized marketing asset
- folder_name follows organizational naming convention (typically matches SMC-ID structure)
- third_party_app tracks which external tool was used (Canva, CapCut, Adobe, etc.)
- Status transitions: Draft → In-Review → Approved/Rejected
- Only approved assets are considered production-ready and can be deployed in campaigns
- version_no increments when assets are updated/replaced, maintaining version history
- created_by and updated_by capture user attribution for audit trail
- remarks field allows CMAs to add context about the asset or approval decisions

**Integration Points:**
- Links to smc_funnel_mapping to maintain traceability from strategy through execution
- Complements content_asset_result table (AI-generated scripts) with final production assets
- Supports complete asset lifecycle: Strategy (Stage 2) → AI Generation (Stage 3) → Production (content_asset_final)

---

## SECTION 5: Data Model & Relationships

### Copy this section to replace Data Model in original document

---

## Data Model

### Key Relationships

**Stage 1 Relationships:**

1. **SMC Hierarchy:**
   - smc_main → contentmarketing_solution_master (Many-to-One via solution_id)
   - smc_main → contentmarketing_product_master (Many-to-One via product_id)
   - smc_main → {smc_channels, smc_personas, smc_problem_statements, smc_solution_features, smc_unfair_advantage} (One-to-Many via smc_id)

2. **Master Table Relationships:**
   - contentmarketing_product_master → contentmarketing_solution_master (Many-to-One via solution_id)
   - smc_channels → contentmarketing_channels_master (Many-to-One via channel_id)

**Stage 2 Relationships:**

3. **Content Mapping Flow:**
   - smc_funnel_mapping → smc_main (Many-to-One via smc_id)
   - smc_funnel_mapping → asset_type (Many-to-One)
   - smc_funnel_mapping → cilos_stage (Many-to-One)
   - smc_funnel_mapping → funnel_stage (Many-to-One)
   - smc_funnel_mapping → content_topic (Many-to-One)
   - smc_funnel_mapping → cta (Many-to-One)

4. **AI-Generated Content References:**
   - content_topic → smc_main (Many-to-One via smc_id)
   - cta → smc_main (Many-to-One via smc_id)

**Stage 3 Relationships:**

5. **Asset Specification System:**
   - asset_channel_specification → asset_type (Many-to-One via asset_type_id)
   - asset_channel_specification → contentmarketing_channels_master (Many-to-One via channel_id, nullable)

6. **Content Creation Workflow:**
   - content_asset_result → content_asset_result (Self-referencing for versioning via parent_result_id)
   - content_asset_final → smc_funnel_mapping (Many-to-One via funnel_mapping_id)

### Cascade Rules

- NO CASCADE DELETE on foreign keys - referential integrity maintained without cascading deletes
- UNIQUE constraints on all SMC child tables for (smc_id, {field}_order) combinations
- Default values applied for status, timestamps, and is_current flags
- smc_id is VARCHAR throughout the system for flexibility and integration with external ID formats

### Index Strategy

- All primary keys have clustered indexes
- Unique constraints create non-clustered indexes automatically
- Foreign keys should have non-clustered indexes for query performance

---

## SECTION 6: Business Rules (Updated)

### Copy this section to replace Business Rules in original document

---

## Business Rules

### Stage 1 Business Rules

1. **SMC Creation & Validation:**
   - Maximum 3-4 problem statements per SMC
   - Maximum 3 solution features per SMC
   - Maximum 3 unfair advantages per SMC
   - Maximum 4 channels per SMC
   - Minimum 1 persona required per SMC
   - All child tables use {field}_order for sequencing (1, 2, 3, etc.)

2. **SMC Approval Workflow:**
   - Default status is 'In-Review'
   - Allowed status transitions: Draft → In-Review → Approved/Rejected
   - smc_id is VARCHAR(255) to support various ID formats including external system integration
   - smc_url stores link to generated Solution Marketing Canvas document
   - pdf_url and png_url populated after SMC approval for sharing

3. **Data Integrity:**
   - UNIQUE constraints enforce no duplicate orders within same smc_id
   - All required fields must be populated before status can move to 'In-Review'
   - Child table records tied to smc_id (varchar reference)

### Stage 2 Business Rules

1. **Content Mapping:**
   - Every mapping row must contain valid smc_id
   - At least one asset type and CTA must be selected
   - System auto-generates content topics and CTAs based on SMC data
   - content_topic and cta tables store smc_id for traceability

2. **AI Content Generation:**
   - Content topics generated from SMC problems, features, and competitive advantages
   - CTAs recommended based on CILOS stage
   - Maximum 500 characters for content topics
   - Maximum 500 characters for CTA text
   - Both are editable by CMAs after AI generation

3. **Funnel Mapping Workflow:**
   - Default status is 'In-Review'
   - Status transitions: Draft → In-Review → Approved/Rejected
   - sort_order determines display sequence in UI
   - pdf_url and word_url populated after content map approval
   - remarks field allows notes/comments for clarification

### Stage 3 Business Rules

1. **Asset Channel Specifications:**
   - Specifications can be defined per asset type globally or per asset/channel combination
   - channel_id NULL indicates specification applies to asset type across all channels
   - All specification fields are optional but recommended for quality assurance
   - Specifications guide both AI content generation and manual asset creation
   - Tool URLs provide direct links to Canva templates, CapCut projects, etc.
   - Supports up to 2 tool integrations per specification
   - additional_specs field supports JSON for extensible requirements

2. **AI Generation & Versioning:**
   - Initial generation: version_no = 1, parent_result_id = NULL, is_current = 1
   - Each regeneration increments version_no
   - Parent-child relationship tracks version history
   - Only one result per builder_id can have is_current = 1
   - user_prompt captures instructions for each generation attempt
   - ai_output_text stores complete generated content
   - word_count calculated automatically from ai_output_text

3. **Export & Deployment:**
   - pdf_url and word_url populated after content approval
   - Current version (is_current = 1) is the version exported
   - Previous versions retained for audit trail
   - Metadata includes: SMC-ID, asset type, CILOS stage, channel

### Cross-Stage Business Rules

1. **Referential Integrity:**
   - smc_id is VARCHAR throughout for flexibility
   - Some references use varchar without FK constraints (by design for external integration)
   - Master tables (solutions, channels, products) use Active/Inactive status rather than deletion
   - Child table order fields enforce UNIQUE(smc_id, order) constraints

2. **Workflow Progression:**
   - Stage 1 SMC must be created before Stage 2 mapping
   - Stage 2 mapping must be approved before Stage 3 asset creation
   - Each stage builds upon data from previous stage
   - Traceability maintained through smc_id references

3. **Audit Trail:**
   - created_at timestamps on most tables
   - created_by captured where applicable
   - Version history maintained in content_asset_result
   - is_current flag identifies active versions

---

## SECTION 7: Naming Convention Standards

### Copy this section to replace Naming Convention Standards in original document

---

## Naming Convention Standards

All exported assets follow this structure:

**[SOLUTION/PRODUCT]-[COUNTRY/REGION]-[FISCAL YEAR]-[ASSET TYPE CODE]_[DESCRIPTOR]**

**Example:** `HED-WSDBD-PH-FY2026_Contact_AD_FB_Video001.mp4`

### Component Breakdown:

- **SOLUTION/PRODUCT:** HED-WSDBD (Higher Ed - Work-Study Degree Digital Business)
- **COUNTRY/REGION:** PH (Philippines)
- **FISCAL YEAR:** FY2026
- **ASSET TYPE CODE:** AD (Advertisement)
- **CHANNEL:** FB (Facebook)
- **DESCRIPTOR:** Video001 (Sequential numbering)

### Benefits:

This ensures assets are:
- Traceable to source SMC and solution
- Organized by geography and timeframe
- Easily searchable and auditable
- Consistent across all campaigns

---

## SECTION 8: Migration Guide (NEW)

### Add this section as a new appendix

---

## Appendix A: Migration Guide from v1.0 to v2.0

### Database Schema Migration Overview

This section documents the migration from the original schema (v1.0) to the current implementation (v2.0).

### 1. Terminology Changes

| Old Term (v1.0) | New Term (v2.0) | Impact |
|-----------------|-----------------|--------|
| Solution Sales Canvas (SSC) | Solution Marketing Canvas (SMC) | All table names, documentation |
| Sub Solution | Product | Table name, column names |
| ssc_* | smc_* | All Stage 1 table prefixes |
| sub_solution_id | product_id | Foreign key references |
| problem_value | statement_value | Column rename in problem_statements |
| problem_order | statement_order | Column rename in problem_statements |

### 2. Removed Tables

#### 2.1 ssc_unique_value_proposition
**Reason for Removal:** Simplified canvas structure - value propositions now captured in solution features and unfair advantages

**Data Migration:** If migrating from v1.0, map UVP data to:
- `smc_solution_features` for product-specific value propositions
- `smc_unfair_advantage` for company-level unique advantages

#### 2.2 ssc_customer_segments
**Reason for Removal:** Consolidated into persona management

**Data Migration:** Merge customer segments into `smc_personas` table

#### 2.3 ssc_competition
**Reason for Removal:** Competitive analysis moved to external tools and strategy documents

**Data Migration:** Archive competitive data; reference in SMC strategy documents

#### 2.4 contentmarketing_sub_solutions_master
**Reason for Removal:** Renamed to better reflect business terminology

**Data Migration:** Direct rename to `contentmarketing_product_master`
- `sub_solution_id` → `product_id`
- `sub_solution_name` → `product_name`
- `sub_solution_code` → `product_code`

#### 2.5 content_asset_builder
**Reason for Removal:** Replaced with more flexible specification system

**Data Migration:**
- Move all std_* fields to `asset_channel_specification` table
- Create reusable specifications instead of per-builder standards
- Link specifications to asset types and channels

### 3. Added Tables

#### 3.1 asset_channel_specification
**Purpose:** Centralized, reusable specification management

**Key Features:**
- Specifications by asset type and/or channel
- Support for multiple content specifications (headline, body, CTA word counts)
- Technical specifications (file format, dimensions, duration)
- Tool integration (Canva, CapCut URLs)
- Flexible additional_specs field for custom requirements

**Migration from content_asset_builder:**
```sql
-- Example migration logic
INSERT INTO asset_channel_specification (
    asset_type_id, channel_id,
    headline_word_count_max, body_word_count_min, body_word_count_max
)
SELECT DISTINCT
    asset_type_id, channel_id,
    std_headline_words_max, std_body_words_min, std_body_words_max
FROM content_asset_builder
WHERE std_headline_words_max IS NOT NULL;
```

#### 3.2 contentmarketing_product_master
**Purpose:** Product catalog replacing sub_solutions

**Key Changes:**
- Clearer naming: product vs sub_solution
- Same structure and relationships as predecessor

### 4. Modified Tables

#### 4.1 smc_main (formerly ssc_main)

**Column Changes:**
```
OLD: sub_solution_id (int)
NEW: product_id (int)

ADDED: pdf_url (varchar(500))
ADDED: png_url (varchar(500))
```

**Migration SQL:**
```sql
-- Rename column
EXEC sp_rename 'ssc_main.sub_solution_id', 'product_id', 'COLUMN';

-- Add new columns
ALTER TABLE smc_main ADD pdf_url varchar(500) NULL;
ALTER TABLE smc_main ADD png_url varchar(500) NULL;
```

#### 4.2 All smc_* tables (formerly ssc_*)

**Migration SQL:**
```sql
-- Rename tables
EXEC sp_rename 'ssc_main', 'smc_main';
EXEC sp_rename 'ssc_channels', 'smc_channels';
EXEC sp_rename 'ssc_personas', 'smc_personas';
EXEC sp_rename 'ssc_problem_statements', 'smc_problem_statements';
EXEC sp_rename 'ssc_solution_features', 'smc_solution_features';
EXEC sp_rename 'ssc_unfair_advantage', 'smc_unfair_advantage';
EXEC sp_rename 'ssc_funnel_mapping', 'smc_funnel_mapping';

-- Update foreign key column names where needed
EXEC sp_rename 'smc_channels.ssc_id', 'smc_id', 'COLUMN';
-- Repeat for all tables with ssc_id references
```

### 5. Application Code Updates Required

#### 5.1 Database Queries
- Update all table references from `ssc_*` to `smc_*`
- Update column references: `sub_solution_id` → `product_id`
- Update column references in problem_statements: `problem_value` → `statement_value`

#### 5.2 API Endpoints
- Update endpoint paths: `/api/ssc/` → `/api/smc/`
- Update JSON response keys to reflect new terminology

#### 5.3 UI Components
- Update labels: "Solution Sales Canvas" → "Solution Marketing Canvas"
- Update labels: "Sub Solution" → "Product"
- Update form field names and validation

#### 5.4 Asset Builder Integration
- Remove direct references to `content_asset_builder` table
- Implement specification lookup from `asset_channel_specification`
- Update asset creation workflow to use centralized specifications

### 6. Migration Checklist

**Database Migration:**
- [ ] Backup v1.0 database
- [ ] Rename tables (ssc_* → smc_*)
- [ ] Rename columns (sub_solution_id → product_id, etc.)
- [ ] Add new columns to smc_main (pdf_url, png_url)
- [ ] Create asset_channel_specification table
- [ ] Migrate data from content_asset_builder to asset_channel_specification
- [ ] Drop removed tables (after data migration confirmation)
- [ ] Update foreign key constraints
- [ ] Rebuild indexes
- [ ] Test referential integrity

**Application Migration:**
- [ ] Update all SQL queries
- [ ] Update API endpoints
- [ ] Update UI components
- [ ] Update documentation
- [ ] Update test cases
- [ ] Run regression tests
- [ ] Deploy to staging
- [ ] User acceptance testing
- [ ] Deploy to production

### 7. Rollback Plan

If rollback is required:
1. Restore v1.0 database backup
2. Revert application code to v1.0 release
3. Document issues encountered
4. Plan remediation before retry

---

## SECTION 9: Complete Table List (v2.0)

### Quick Reference - All 19 Tables

---

### Stage 1: SMC Foundation (6 tables + 3 master tables)

**SMC Tables:**
1. `smc_main` - Main canvas records
2. `smc_channels` - Marketing channels per SMC
3. `smc_personas` - Buyer personas
4. `smc_problem_statements` - Customer problems
5. `smc_solution_features` - Solution features
6. `smc_unfair_advantage` - Competitive advantages

**Master Tables:**
7. `contentmarketing_solution_master` - Solutions catalog
8. `contentmarketing_product_master` - Products catalog
9. `contentmarketing_channels_master` - Channels catalog

### Stage 2: Content Strategy (5 tables)

10. `asset_type` - Asset types catalog
11. `cilos_stage` - CILOS stages
12. `funnel_stage` - Funnel stages
13. `content_topic` - AI-generated topics
14. `cta` - Call-to-action library
15. `smc_funnel_mapping` - Content strategy mapping

### Stage 3: Asset Creation (4 tables)

16. `brand_guideline_ref` - Brand guidelines reference
17. `asset_channel_specification` - Asset specifications by channel
18. `content_asset_result` - AI-generated content versions
19. `content_asset_final` - Final published assets

---

## SECTION 10: ERD Diagram Description (Updated)

### Entity Relationship Diagram Overview

---

### Primary Data Flow (v2.0)

```
contentmarketing_solution_master
  ↓ (solution_id)
contentmarketing_product_master
  ↓ (product_id)
smc_main (smc_id) ← Central hub
  ↓ (Referenced by multiple tables)
  ├── smc_personas
  ├── smc_problem_statements
  ├── smc_solution_features
  ├── smc_unfair_advantage
  ├── smc_channels
  ├── content_topic
  ├── cta
  └── smc_funnel_mapping
       ↓ (funnel_mapping_id)
     content_asset_final
```

### Asset Specification Flow (NEW in v2.0)

```
asset_type + contentmarketing_channels_master
  ↓
asset_channel_specification (defines specs per asset/channel)
  ↓ (referenced during asset creation)
content_asset_result (AI generation follows specs)
  ↓
content_asset_final (final assets meet specs)
```

### Content Generation Flow

```
smc_funnel_mapping (defines what to create)
  ↓
content_asset_result (AI-generated content with versioning)
  ↓ (parent_result_id → result_id for version chain)
content_asset_result (v2, v3, etc.)
  ↓
content_asset_final (published assets)
```

---

## Summary of Changes

### What's Different in v2.0

**Removed Complexity:**
- ✂️ 5 tables removed (UVP, customer segments, competition, sub_solutions_master, asset_builder)
- ✂️ Embedded standards system replaced with centralized specifications

**Added Flexibility:**
- ✅ Centralized specification system with tool integration
- ✅ Better terminology (SMC, Product)
- ✅ Enhanced export capabilities (pdf_url, png_url)
- ✅ Reusable specifications across assets

**Improved Structure:**
- 🔄 Cleaner separation of concerns
- 🔄 More maintainable schema
- 🔄 Better support for external tool integrations
- 🔄 Flexible JSON-based additional specifications

---

## Conclusion

This v2.0 schema represents a significant improvement in:
- **Clarity:** Better naming conventions
- **Maintainability:** Centralized specifications
- **Flexibility:** Reusable components and tool integrations
- **Scalability:** Support for unlimited asset types and channels

The migration from v1.0 preserves all critical data while streamlining the structure for better performance and easier maintenance.

---

**End of Documentation**

*For questions or clarifications, contact: John Edward Oblepias*
*Last Updated: November 18, 2025*

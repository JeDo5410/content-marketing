# Table Mapping: v1.0 (PDF) vs v2.0 (Current Database)

## Complete Table-by-Table Comparison

---

## Stage 1: Solution Marketing Canvas Foundation

### ✅ RENAMED: ssc_main → smc_main

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | ssc_id | smc_id | Renamed table only |
| ✓ Same | solution_id | solution_id | No change |
| 🔄 CHANGED | sub_solution_id | product_id | **Column renamed** |
| ✓ Same | ssc_url | smc_url | No change |
| ✓ Same | created_date | created_date | No change |
| ✓ Same | created_by | created_by | No change |
| ✓ Same | status | status | No change |
| ➕ NEW | - | **pdf_url** | **Added in v2.0** |
| ➕ NEW | - | **png_url** | **Added in v2.0** |

**Foreign Key Changes:**
- v1.0: `sub_solution_id → contentmarketing_sub_solutions_master`
- v2.0: `product_id → contentmarketing_product_master`

---

### ✅ RENAMED: ssc_channels → smc_channels

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | id | id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| ✓ Same | channel_id | channel_id | No change |
| ✓ Same | channel_order | channel_order | No change |

**No structural changes, only table name**

---

### ✅ RENAMED: ssc_personas → smc_personas

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | id | id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| ✓ Same | persona_value | persona_value | No change |
| ✓ Same | persona_order | persona_order | No change |

**No structural changes, only table name**

---

### ✅ RENAMED: ssc_problem_statements → smc_problem_statements

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | id | id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| 🔄 CHANGED | **problem_value** | **statement_value** | **Column renamed** |
| 🔄 CHANGED | **problem_order** | **statement_order** | **Column renamed** |

**Column renames for consistency**

---

### ✅ RENAMED: ssc_solution_features → smc_solution_features

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | id | id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| ✓ Same | feature_value | feature_value | No change |
| ✓ Same | feature_order | feature_order | No change |

**No structural changes, only table name**

---

### ✅ RENAMED: ssc_unfair_advantage → smc_unfair_advantage

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | id | id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| ✓ Same | advantage_value | advantage_value | No change |
| ✓ Same | advantage_order | advantage_order | No change |

**No structural changes, only table name**

---

### ❌ REMOVED: ssc_unique_value_proposition

**Status:** Table completely removed in v2.0

**Original Structure (v1.0):**
- id (int, PK)
- ssc_id (varchar, FK)
- uvp_value (varchar)
- uvp_order (int)

**Reason for Removal:** Simplified canvas structure

**Data Migration Path:**
- Map to `smc_solution_features` for product-specific propositions
- Map to `smc_unfair_advantage` for company-level advantages

---

### ❌ REMOVED: ssc_customer_segments

**Status:** Table completely removed in v2.0

**Original Structure (v1.0):**
- id (int, PK)
- ssc_id (varchar, FK)
- segment_value (varchar)
- segment_order (int)

**Reason for Removal:** Consolidated into persona management

**Data Migration Path:**
- Merge into `smc_personas` table

---

### ❌ REMOVED: ssc_competition

**Status:** Table completely removed in v2.0

**Original Structure (v1.0):**
- id (int, PK)
- ssc_id (varchar, FK)
- competition_value (varchar)
- competition_order (int)

**Reason for Removal:** Moved to external competitive analysis tools

**Data Migration Path:**
- Archive data
- Reference in external strategy documents

---

### 🔄 REPLACED: contentmarketing_sub_solutions_master → contentmarketing_product_master

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| 🔄 CHANGED | **sub_solution_id** | **product_id** | **Column renamed** |
| ✓ Same | solution_id | solution_id | No change |
| 🔄 CHANGED | **sub_solution_name** | **product_name** | **Column renamed** |
| 🔄 CHANGED | **sub_solution_code** | **product_code** | **Column renamed** |
| ✓ Same | description | description | No change |
| ✓ Same | status | status | No change |
| ✓ Same | created_at | created_at | No change |

**Structure identical, only naming improved**

---

### ✅ NO CHANGE: contentmarketing_solution_master

| Status | Column Name | Notes |
|--------|-------------|-------|
| ✓ Same | solution_id | No change |
| ✓ Same | solution_name | No change |
| ✓ Same | solution_code | No change |
| ✓ Same | description | No change |
| ✓ Same | status | No change |
| ✓ Same | created_at | No change |

**No changes to this table**

---

### ✅ NO CHANGE: contentmarketing_channels_master

| Status | Column Name | Notes |
|--------|-------------|-------|
| ✓ Same | channel_id | No change |
| ✓ Same | channel_name | No change |
| ✓ Same | channel_code | No change |
| ✓ Same | description | No change |
| ✓ Same | status | No change |
| ✓ Same | created_at | No change |

**No changes to this table**

---

## Stage 2: Content Strategy & Funnel Mapping

### ✅ NO CHANGE: asset_type

All columns unchanged.

### ✅ NO CHANGE: cilos_stage

All columns unchanged.

### ✅ NO CHANGE: funnel_stage

All columns unchanged.

---

### ✅ RENAMED: content_topic (FK reference updated)

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | content_topic_id | content_topic_id | No change |
| ✓ Same | content_topic | content_topic | No change |
| 🔄 CHANGED | ssc_id | smc_id | **FK reference updated** |
| ✓ Same | created_at | created_at | No change |

**Only FK reference updated from ssc_id to smc_id**

---

### ✅ RENAMED: cta (FK reference updated)

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | cta_id | cta_id | No change |
| ✓ Same | cta_text | cta_text | No change |
| 🔄 CHANGED | ssc_id | smc_id | **FK reference updated** |
| ✓ Same | created_at | created_at | No change |

**Only FK reference updated from ssc_id to smc_id**

---

### ✅ RENAMED: ssc_funnel_mapping → smc_funnel_mapping

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | funnel_mapping_id | funnel_mapping_id | No change |
| 🔄 CHANGED | ssc_id | smc_id | FK reference updated |
| ✓ Same | pdf_url | pdf_url | No change |
| ✓ Same | word_url | word_url | No change |
| ✓ Same | funnel_stage_id | funnel_stage_id | No change |
| ✓ Same | cilos_stage_id | cilos_stage_id | No change |
| ✓ Same | asset_type_id | asset_type_id | No change |
| ✓ Same | content_topic_id | content_topic_id | No change |
| ✓ Same | cta_id | cta_id | No change |
| ✓ Same | sort_order | sort_order | No change |
| ✓ Same | status | status | No change |
| ✓ Same | remarks | remarks | No change |
| ✓ Same | created_by | created_by | No change |
| ✓ Same | created_at | created_at | No change |
| ✓ Same | updated_at | updated_at | No change |

**No structural changes, only table name and FK reference**

---

## Stage 3: Asset Specification & Content Workflow

### ✅ NO CHANGE: brand_guideline_ref

All columns unchanged.

---

### ❌ REMOVED: content_asset_builder

**Status:** Table completely removed in v2.0

**Original Structure (v1.0):**
- builder_id (bigint, PK)
- funnel_mapping_id (int, FK)
- ssc_id (varchar, FK)
- channel_id (int, FK)
- std_width_px (int)
- std_height_px (int)
- std_aspect_ratio (varchar)
- std_headline_words_max (int)
- std_body_words_min (int)
- std_body_words_max (int)
- std_cta_words_max (int)

**Reason for Removal:** Architecture improvement - replaced with centralized specification system

**Replaced By:** `asset_channel_specification`

---

### ➕ NEW: asset_channel_specification

**Status:** New table in v2.0

**Purpose:** Centralized, reusable asset specifications by channel

**Structure:**
- spec_id (bigint, PK) - **NEW**
- asset_type_id (int, FK) - **Replaces builder FK structure**
- channel_id (int, FK, nullable) - **Nullable for general specs**
- file_format (varchar) - **NEW**
- paper_size (varchar) - **NEW**
- audio_quality (varchar) - **NEW**
- duration_min (varchar) - **NEW**
- duration_max (varchar) - **NEW**
- headline_word_count_min (int) - **NEW - was std_headline_words_max**
- headline_word_count_max (int) - **NEW**
- subheadline_word_count_min (int) - **NEW**
- subheadline_word_count_max (int) - **NEW**
- body_word_count_min (int) - **From std_body_words_min**
- body_word_count_max (int) - **From std_body_words_max**
- cta_word_count_min (int) - **NEW**
- cta_word_count_max (int) - **From std_cta_words_max**
- additional_specs (nvarchar max) - **NEW - JSON support**
- status (varchar) - **NEW**
- created_at (datetime2) - **NEW**
- created_by (varchar) - **NEW**
- updated_at (datetime2) - **NEW**
- updated_by (varchar) - **NEW**
- tool_url (varchar) - **NEW - Canva integration**
- tool_button_text (varchar) - **NEW**
- tool_url_2 (varchar) - **NEW - Secondary tool**
- tool_button_text_2 (varchar) - **NEW**

**Key Improvements:**
- Reusable specifications (not tied to single builder session)
- Support for multiple content sections (headline, subheadline, body, CTA)
- Technical specs (format, duration, dimensions)
- Tool integration (Canva, CapCut URLs)
- Flexible JSON for custom requirements
- Proper audit fields

---

### ✅ NO CHANGE: content_asset_result

All columns unchanged.

---

### ✅ MINOR UPDATE: content_asset_final

| Status | Column Name (v1.0) | Column Name (v2.0) | Notes |
|--------|-------------------|-------------------|-------|
| ✓ Same | final_asset_id | final_asset_id | No change |
| ✓ Same | funnel_mapping_id | funnel_mapping_id | FK now points to smc_funnel_mapping |
| ✓ Same | asset_url | asset_url | No change |
| ✓ Same | folder_name | folder_name | Naming convention updated to SMC |
| ✓ Same | third_party_app | third_party_app | No change |
| ✓ Same | status | status | No change |
| ✓ Same | remarks | remarks | No change |
| ✓ Same | created_by | created_by | No change |
| ✓ Same | created_at | created_at | No change |
| ✓ Same | updated_by | updated_by | No change |
| ✓ Same | updated_at | updated_at | No change |
| ✓ Same | version_no | version_no | No change |

**Structure unchanged, FK reference updated**

---

## Summary Statistics

### Tables by Status

| Status | Count | Tables |
|--------|-------|--------|
| ✅ No Change | 7 | asset_type, cilos_stage, funnel_stage, brand_guideline_ref, content_asset_result, contentmarketing_solution_master, contentmarketing_channels_master |
| 🔄 Renamed (structure same) | 7 | ssc_main→smc_main, ssc_channels→smc_channels, ssc_personas→smc_personas, ssc_problem_statements→smc_problem_statements, ssc_solution_features→smc_solution_features, ssc_unfair_advantage→smc_unfair_advantage, ssc_funnel_mapping→smc_funnel_mapping |
| 🔄 FK Updated | 2 | content_topic, cta |
| 🔄 Replaced | 1 | contentmarketing_sub_solutions_master→contentmarketing_product_master |
| ❌ Removed | 4 | ssc_unique_value_proposition, ssc_customer_segments, ssc_competition, content_asset_builder |
| ➕ Added | 1 | asset_channel_specification |

**Total v1.0 Tables:** 23
**Total v2.0 Tables:** 19
**Net Change:** -4 tables (simplified structure)

---

## Column Changes Summary

### Added Columns (3)

1. **smc_main.pdf_url** - Export functionality
2. **smc_main.png_url** - Export functionality
3. **asset_channel_specification.*** - Entire new table (24 columns)

### Removed Columns (15)

1. **content_asset_builder.*** - Entire table removed (11 columns)
2. **ssc_unique_value_proposition.*** - Entire table removed
3. **ssc_customer_segments.*** - Entire table removed
4. **ssc_competition.*** - Entire table removed

### Renamed Columns (6)

1. smc_main: **sub_solution_id** → **product_id**
2. smc_problem_statements: **problem_value** → **statement_value**
3. smc_problem_statements: **problem_order** → **statement_order**
4. contentmarketing_product_master: **sub_solution_id** → **product_id**
5. contentmarketing_product_master: **sub_solution_name** → **product_name**
6. contentmarketing_product_master: **sub_solution_code** → **product_code**

---

## Impact Assessment

### High Impact Changes
1. ⚠️ Table renames (ssc_* → smc_*) - **Affects all queries**
2. ⚠️ content_asset_builder removal - **Architectural change**
3. ⚠️ Column renames in smc_main - **Foreign key updates needed**

### Medium Impact Changes
1. ⚠️ Product terminology changes - **Business logic updates**
2. ⚠️ asset_channel_specification addition - **New functionality**

### Low Impact Changes
1. ℹ️ Addition of pdf_url, png_url - **Optional enhancements**
2. ℹ️ Removed UVP/segments/competition - **Data archival needed**

---

*This document provides a complete mapping between v1.0 (PDF documentation) and v2.0 (current database implementation)*

*Last Updated: November 18, 2025*

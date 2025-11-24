# Database Schema Changes - Quick Reference Guide
## From v1.0 to v2.0

---

## 🔄 Terminology Changes

| Old (v1.0) | New (v2.0) | Everywhere |
|------------|------------|------------|
| SSC | SMC | ✓ All tables, docs, code |
| Solution Sales Canvas | Solution Marketing Canvas | ✓ All documentation |
| Sub Solution | Product | ✓ All tables, columns |
| ssc_* | smc_* | ✓ All table names |

---

## ❌ Removed Tables (5)

### 1. ssc_unique_value_proposition
- **Why removed:** Simplified canvas structure
- **Data goes to:** `smc_solution_features` or `smc_unfair_advantage`

### 2. ssc_customer_segments
- **Why removed:** Consolidated functionality
- **Data goes to:** `smc_personas`

### 3. ssc_competition
- **Why removed:** Moved to external tools
- **Data goes to:** Archive/strategy documents

### 4. contentmarketing_sub_solutions_master
- **Why removed:** Renamed for clarity
- **Replaced by:** `contentmarketing_product_master`

### 5. content_asset_builder
- **Why removed:** Architecture improvement
- **Replaced by:** `asset_channel_specification`

---

## ✅ Added Tables (2)

### 1. asset_channel_specification
**Purpose:** Centralized asset specifications by channel

**Key Features:**
- Reusable specifications
- Tool integration (Canva, CapCut)
- Word count ranges for content sections
- File format, duration, dimensions
- Flexible JSON for custom specs

**Replaces:** Embedded std_* fields from content_asset_builder

### 2. contentmarketing_product_master
**Purpose:** Product catalog

**Key Features:**
- Same structure as old sub_solutions_master
- Better naming: product_id, product_name, product_code
- Links to solutions via solution_id

---

## 🔧 Modified Tables

### smc_main (formerly ssc_main)

**Column Changes:**
```diff
- sub_solution_id (int)
+ product_id (int)
+ pdf_url (varchar(500))
+ png_url (varchar(500))
```

### smc_problem_statements

**Column Changes:**
```diff
- problem_value
+ statement_value
- problem_order
+ statement_order
```

### All ssc_* tables → smc_* tables
- ssc_main → smc_main
- ssc_channels → smc_channels
- ssc_personas → smc_personas
- ssc_problem_statements → smc_problem_statements
- ssc_solution_features → smc_solution_features
- ssc_unfair_advantage → smc_unfair_advantage
- ssc_funnel_mapping → smc_funnel_mapping

---

## 📊 Current Schema Summary

### Total Tables: 19

**By Stage:**
- Stage 1 (SMC Foundation): 9 tables
- Stage 2 (Content Strategy): 6 tables
- Stage 3 (Asset Creation): 4 tables

**By Type:**
- Main tables: 16
- Master/lookup tables: 3

---

## 🗺️ Architecture Changes

### Old Architecture (v1.0)
```
ssc_funnel_mapping
  ↓
content_asset_builder (with embedded std_* fields)
  ↓
content_asset_result
  ↓
content_asset_final
```

### New Architecture (v2.0)
```
smc_funnel_mapping
  ↓
[Look up specs from asset_channel_specification]
  ↓
content_asset_result (follows specs)
  ↓
content_asset_final
```

**Benefits:**
✓ Reusable specifications across multiple assets
✓ Centralized management
✓ Tool integration support
✓ Flexible JSON-based extensions

---

## 📝 Documentation Update Checklist

### Search & Replace Operations

#### Global Replacements:
- [ ] "SSC" → "SMC" (check context)
- [ ] "Solution Sales Canvas" → "Solution Marketing Canvas"
- [ ] "Sub Solution" → "Product"
- [ ] "sub_solution" → "product"
- [ ] "ssc_" → "smc_" (in table names)

#### Table-Specific Updates:

**Remove these sections:**
- [ ] ssc_unique_value_proposition
- [ ] ssc_customer_segments
- [ ] ssc_competition
- [ ] contentmarketing_sub_solutions_master
- [ ] content_asset_builder

**Add these sections:**
- [ ] asset_channel_specification (full documentation)
- [ ] contentmarketing_product_master (renamed from sub_solutions)

**Update these sections:**
- [ ] smc_main table (new columns: product_id, pdf_url, png_url)
- [ ] smc_problem_statements (renamed columns)
- [ ] All ERD diagrams
- [ ] All business rules referencing removed tables

---

## 🔑 Key Foreign Key Changes

### Old (v1.0)
```sql
ssc_main.sub_solution_id → contentmarketing_sub_solutions_master.sub_solution_id
```

### New (v2.0)
```sql
smc_main.product_id → contentmarketing_product_master.product_id
```

---

## 💡 Benefits of v2.0

### 1. Clearer Terminology
- "Marketing Canvas" better reflects purpose
- "Product" is clearer than "Sub Solution"

### 2. Simplified Structure
- Removed 3 underutilized tables
- Consolidated overlapping functionality
- Cleaner data model

### 3. Better Flexibility
- Centralized specifications
- Reusable across assets
- Tool integration support
- JSON-based extensibility

### 4. Enhanced Features
- Export to PDF and PNG from SMC
- Tool links (Canva, CapCut)
- Specification templates per channel

---

## 🚀 Migration Priority

### High Priority (Breaking Changes)
1. ✓ Rename all ssc_* tables to smc_*
2. ✓ Update smc_main: sub_solution_id → product_id
3. ✓ Create asset_channel_specification
4. ✓ Migrate specifications from content_asset_builder

### Medium Priority (Data Consolidation)
5. Archive ssc_unique_value_proposition data
6. Archive ssc_customer_segments data
7. Archive ssc_competition data

### Low Priority (Enhancements)
8. Add tool_url links to specifications
9. Add pdf_url, png_url to existing SMCs

---

## 📋 SQL Quick Reference

### Rename Tables
```sql
EXEC sp_rename 'ssc_main', 'smc_main';
EXEC sp_rename 'ssc_channels', 'smc_channels';
EXEC sp_rename 'ssc_personas', 'smc_personas';
-- etc.
```

### Rename Columns
```sql
EXEC sp_rename 'smc_main.sub_solution_id', 'product_id', 'COLUMN';
EXEC sp_rename 'smc_problem_statements.problem_value', 'statement_value', 'COLUMN';
```

### Add New Columns
```sql
ALTER TABLE smc_main ADD pdf_url VARCHAR(500) NULL;
ALTER TABLE smc_main ADD png_url VARCHAR(500) NULL;
```

---

## 🎯 Testing Checklist

### Database Tests
- [ ] All foreign keys resolve correctly
- [ ] Unique constraints work as expected
- [ ] Default values apply correctly
- [ ] Status check constraints function

### Application Tests
- [ ] SMC creation workflow
- [ ] Funnel mapping creation
- [ ] Asset specification lookup
- [ ] Content generation with specs
- [ ] Final asset creation

### Integration Tests
- [ ] Tool URL links work
- [ ] PDF/PNG export functionality
- [ ] Specification application to assets
- [ ] Version control in content_asset_result

---

## 📞 Support

**Questions about the schema changes?**
Contact: John Edward Oblepias

**Need help with migration?**
Refer to: `DATABASE_SCHEMA_DOCUMENTATION_UPDATED_v2.md` - Appendix A: Migration Guide

---

*Last Updated: November 18, 2025*

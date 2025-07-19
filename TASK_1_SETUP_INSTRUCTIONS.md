# Task 1: Setup Instructions for End-to-End Testing

## 📋 Overview
This guide will help you set up the sample data in BigQuery and test the complete Task 1 migration pipeline from raw data to final financial reports.

## 🗂️ Sample Data Files Created

The following CSV files have been created in the `sample_data/` folder:

1. **`raw_gl_headers.csv`** - 15 sample GL transaction headers (2023-2024 data)
2. **`raw_gl_lines.csv`** - 32 corresponding GL transaction lines 
3. **`raw_account_hierarchy.csv`** - 26 accounts with proper hierarchy structure

**Note**: You only need to upload these 3 CSV files. The `code_combinations` table mentioned in some documentation is not required for this demo.

## 🔧 Step 1: Create BigQuery Dataset and Upload Data

### 1.1 Create the RAW dataset in BigQuery

```sql
-- Run in BigQuery Console
CREATE SCHEMA IF NOT EXISTS `bqni-466316.raw_finance`
OPTIONS (
  description = "Raw financial data for Task 1 migration testing",
  location = "europe-southwest1"
);
```

### 1.2 Upload CSV files to BigQuery

#### Option A: Using BigQuery Web Console
1. Go to BigQuery Console → `bqni-466316` → `raw_finance`
2. Click "Create Table" for each CSV file:

**For gl_headers:**
- Source: Upload → Choose `sample_data/raw_gl_headers.csv`
- Destination: 
  - Dataset: `raw_finance`
  - Table: `gl_headers`
- Schema: Auto-detect ✅
- Advanced options → Header rows to skip: `1`

**For gl_lines:**
- Source: Upload → Choose `sample_data/raw_gl_lines.csv`
- Destination: 
  - Dataset: `raw_finance`
  - Table: `gl_lines`
- Schema: Auto-detect ✅
- Advanced options → Header rows to skip: `1`

**For account_hierarchy:**
- Source: Upload → Choose `sample_data/raw_account_hierarchy.csv`
- Destination: 
  - Dataset: `raw_finance`
  - Table: `account_hierarchy`
- Schema: Auto-detect ✅
- Advanced options → Header rows to skip: `1`

#### Option B: Using bq command line
```bash
# Upload gl_headers
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  --autodetect \
  raw_finance.gl_headers \
  sample_data/raw_gl_headers.csv

# Upload gl_lines
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  --autodetect \
  raw_finance.gl_lines \
  sample_data/raw_gl_lines.csv

# Upload account_hierarchy
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  --autodetect \
  raw_finance.account_hierarchy \
  sample_data/raw_account_hierarchy.csv
```

## 🏗️ Step 2: Update dbt Project Configuration

### 2.1 Update dbt_project.yml

Make sure your `dbt_project.yml` includes the Task 1 models:

```yaml
# Add to dbt_project.yml
models:
  github_native_instruments:
    +materialized: view
    staging:
      +materialized: view
    core:
      +materialized: table
    marts:
      +materialized: table
```

### 2.2 Create additional datasets for the pipeline

```sql
-- Run in BigQuery Console
CREATE SCHEMA IF NOT EXISTS `bqni-466316.staging`
OPTIONS (description = "Staging layer for cleaned data");

CREATE SCHEMA IF NOT EXISTS `bqni-466316.core`
OPTIONS (description = "Core business logic layer");

CREATE SCHEMA IF NOT EXISTS `bqni-466316.marts`
OPTIONS (description = "Business-specific aggregated models");
```

## 🚀 Step 3: Run the dbt Pipeline

### 3.1 Install dbt dependencies

```bash
# Activate your dbt environment
source dbt_env/bin/activate
source load_env.sh

# Install any required packages
dbt deps
```

### 3.2 Test source data

```bash
# Test that sources are accessible
dbt source freshness --select source:raw_finance

# Check if models compile correctly
dbt parse
```

### 3.3 Run the complete pipeline

```bash
# Run all Task 1 financial models
dbt run --select +mart_balance_sheet

# Or run step by step:
# 1. Staging models
dbt run --select models.github_native_instruments.staging.stg_gl_headers models.github_native_instruments.staging.stg_gl_lines models.github_native_instruments.staging.stg_account_hierarchy

# 2. Core models  
dbt run --select models.github_native_instruments.core.dim_accounts models.github_native_instruments.core.fct_transactions

# 3. Marts models
dbt run --select models.github_native_instruments.marts.mart_balance_sheet
```

### 3.4 Run tests

```bash
# Run all tests for Task 1 models
dbt test --select +mart_balance_sheet
```

### 3.5 Generate documentation

```bash
# Generate and serve documentation
dbt docs generate
dbt docs serve
```

## 📊 Step 4: Verify Results in BigQuery

### 4.1 Check staging models

```sql
-- Verify staging data
SELECT * FROM `bqni-466316.staging.stg_gl_headers` LIMIT 10;
SELECT * FROM `bqni-466316.staging.stg_gl_lines` LIMIT 10;
SELECT * FROM `bqni-466316.staging.stg_account_hierarchy` LIMIT 10;
```

### 4.2 Check core models

```sql
-- Check account dimension
SELECT 
    account_code,
    account_name,
    account_type,
    statement_type,
    financial_section
FROM `bqni-466316.core.dim_accounts`
ORDER BY account_code;

-- Check transaction fact table
SELECT 
    COUNT(*) as total_transactions,
    COUNT(DISTINCT account_code) as unique_accounts,
    SUM(functional_amount) as total_amount
FROM `bqni-466316.core.fct_transactions`;
```

### 4.3 Check balance sheet mart

```sql
-- Verify balance sheet by account type
SELECT 
    account_type,
    financial_section,
    COUNT(*) as account_count,
    SUM(period_end_balance) as section_total
FROM `bqni-466316.marts.mart_balance_sheet`
WHERE period_key = '2024-03'
GROUP BY 1,2
ORDER BY 1,2;

-- Check balance sheet balancing
SELECT 
    period_key,
    total_assets,
    total_liabilities,
    total_equity,
    balance_sheet_difference
FROM `bqni-466316.marts.mart_balance_sheet`
WHERE period_key = '2024-03'
LIMIT 1;
```

## 🔍 Step 5: Data Quality Validation

### 5.1 Expected Results

With the sample data, you should see:

**Transaction Summary:**
- 15 GL headers (transactions)
- 32 GL lines (journal entries)
- Transactions from Dec 2023 - Mar 2024
- Multiple currencies (USD, EUR)
- Various transaction types (INVOICE, PAYMENT, SALES, etc.)

**Account Summary:**
- 26 accounts across all financial statement categories
- 2-level hierarchy (summary + detail accounts)
- Assets, Liabilities, Equity, Revenue, and Expense accounts

**Balance Sheet:**
- Should balance (Assets = Liabilities + Equity)
- Period-end balances by account
- Variance analysis vs. prior periods

### 5.2 Troubleshooting

**Common Issues:**

1. **Source not found errors**
   - Verify dataset names match exactly (`raw_finance`)
   - Check environment variables are loaded correctly

2. **Permission errors**
   - Ensure service account has BigQuery Data Editor role
   - Verify project ID in environment variables

3. **Schema errors**
   - Check CSV uploads completed successfully
   - Verify column names match exactly

4. **Empty results**
   - Confirm CSV files uploaded with data
   - Check date filters in models (should include 2023-2024)

## 🎯 Step 6: Google Sheets Integration (Optional)

To complete the end-to-end demo:

1. **Create a new Google Sheet**
2. **Data → Data connectors → Connect to BigQuery**
3. **Select project:** `bqni-466316`
4. **Select table:** `marts.mart_balance_sheet`
5. **Create pivot table or chart** for financial reporting

## ✅ Success Criteria

The pipeline is working correctly if:

- ✅ All staging models run without errors
- ✅ Core models populate with expected record counts
- ✅ Balance sheet mart shows proper financial statement structure
- ✅ Balance sheet balances (Assets = Liabilities + Equity)
- ✅ All tests pass
- ✅ Documentation generates showing lineage

## 📈 Next Steps

Once the basic pipeline is working:

1. **Add more sample data** for multiple periods
2. **Create Income Statement mart** (similar to Balance Sheet)
3. **Add data quality tests** and monitoring
4. **Set up incremental processing** for larger datasets
5. **Create Google Sheets dashboards** for end users

---

This setup demonstrates the complete **QlikSense → dbt + BigQuery + Google Sheets** migration architecture for Task 1! 
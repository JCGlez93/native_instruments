# Native Instruments - dbt Data Pipeline

Professional dbt project with BigQuery integration for data analytics.

## 🚀 Project Overview

This project implements a complete **end-to-end data pipeline** using:
- ✅ **dbt Core** with BigQuery
- ✅ **Professional data architecture** (staging → core → marts)
- ✅ **Comprehensive testing & documentation**
- ✅ **Test data for development**

## 📊 Architecture

```
📁 Data Layers
├── 🌱 Seeds (CSV test data)
├── 🔧 Staging (data cleaning)
├── 🏗️ Core (dimensions & facts)  
└── 📈 Marts (business ready)
```

### BigQuery Structure
```
Development:     bqni-466316.DEV_staging.*
                bqni-466316.DEV_core.*
                bqni-466316.DEV_marts.*

Production:      bqni-466316.dbt_staging.*
                bqni-466316.dbt_core.*
                bqni-466316.dbt_marts.*
```

## 🛠️ Setup

### Prerequisites
- Python 3.11+
- BigQuery project with credentials
- Virtual environment with dbt-bigquery

### Quick Start

1. **Clone and setup:**
```bash
git clone https://github.com/JCGlez93/native_instruments.git
cd native_instruments
source dbt_env/bin/activate  # Activate virtual environment
```

2. **Load environment:**
```bash
source load_env.sh
```

3. **Run pipeline:**
```bash
dbt seed      # Load test data
dbt run       # Execute models
dbt test      # Validate data
dbt docs generate && dbt docs serve  # View docs
```

## 📁 Project Structure

```
├── models/
│   ├── staging/     # Data cleaning & standardization
│   ├── core/        # Dimensions & fact tables
│   └── marts/       # Business-ready analytics
├── seeds/           # Test data (CSV files)
├── macros/          # Custom dbt macros  
└── tests/           # Data quality tests
```

## 🎯 Key Features

- ✅ **End-to-end tested** pipeline
- ✅ **Professional naming** conventions
- ✅ **Comprehensive documentation** 
- ✅ **Multi-environment** setup
- ✅ **Industry best practices**
- ✅ **BigQuery optimized** models

## 📝 Models

### Seeds
- `users_test.csv` - Test user data
- `events_test.csv` - Test event data

### Staging
- `stg_users_test` - Cleaned user data
- `stg_events_test` - Cleaned event data

### Core
- `dim_users_test` - User dimension table
- `fct_events_test` - Event fact table

### Marts
- `user_engagement_summary_test` - User engagement analytics

## 🔧 Configuration

The project uses environment variables for BigQuery connection:
- `BIGQUERY_PROJECT_ID`
- `BIGQUERY_DATASET_DEV`
- `BIGQUERY_DATASET_STAGING`
- etc.

Configure these in your `.env` file or load them using `load_env.sh`.

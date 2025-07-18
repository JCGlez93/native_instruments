# Native Instruments - dbt Data Pipeline

Professional dbt project with BigQuery integration and CI/CD automation.

## 🚀 Project Overview

This project implements a complete **end-to-end data pipeline** using:
- ✅ **dbt Core** with BigQuery
- ✅ **Professional data architecture** (staging → core → marts)
- ✅ **CI/CD with GitHub Actions**
- ✅ **Comprehensive testing & documentation**

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
- GitHub account (for CI/CD)

### Quick Start

1. **Clone and setup:**
```bash
git clone https://github.com/JCGlez93/native_instruments.git
cd native_instruments
source dbt_env/bin/activate
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

## 🚀 CI/CD Pipeline

Automated workflows with GitHub Actions:
- **Pull Requests**: Automated testing
- **Main branch**: Production deployment
- **Multiple environments**: dev, CI, prod

See `CI_CD_SETUP.md` for detailed configuration.

## 📁 Project Structure

```
├── models/
│   ├── staging/     # Data cleaning & standardization
│   ├── core/        # Dimensions & fact tables
│   └── marts/       # Business-ready analytics
├── seeds/           # Test data (CSV files)
├── macros/          # Custom dbt macros  
├── tests/           # Data quality tests
└── .github/workflows/  # CI/CD automation
```

## 🎯 Key Features

- ✅ **End-to-end tested** pipeline
- ✅ **Professional naming** conventions
- ✅ **Comprehensive documentation** 
- ✅ **Multi-environment** setup
- ✅ **Automated deployments**
- ✅ **Industry best practices**

# GitHub Native Instruments - dbt Project

This project uses dbt Core with BigQuery for data analysis.

## Setup

### Prerequisites
- Python 3.7+
- dbt-bigquery
- BigQuery credentials

### Installation

1. Create and activate a virtual environment:
```bash
# Create virtual environment
python3 -m venv dbt_env

# Activate virtual environment
# On macOS/Linux:
source dbt_env/bin/activate
# On Windows:
# dbt_env\Scripts\activate
```

2. Install dbt-bigquery:
```bash
pip install dbt-bigquery
```

3. Credentials are already configured using environment variables:
   - The `.env` file contains all necessary configurations
   - The JSON credentials file is already in the project
   - Variables are loaded automatically from `profiles.yml`

4. Load environment variables before using dbt:
```bash
# Option 1: Use the included script
source ./load_env.sh

# Option 2: Load manually
source .env
export $(grep -v '^#' .env | xargs)
```

### Basic Commands

```bash
# ALWAYS load environment variables first
source ./load_env.sh

# Verify connection
dbt debug

# Install dependencies
dbt deps

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve

# Complete workflow
dbt run && dbt test && dbt docs generate
```

## Project Structure

```
├── models/          # SQL models
├── analyses/        # Ad-hoc analyses
├── tests/          # Custom tests
├── seeds/          # Seed data
├── macros/         # Reusable macros
└── snapshots/      # SCD snapshots
``` 
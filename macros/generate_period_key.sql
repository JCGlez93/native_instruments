{% macro generate_period_key(year_column, period_column) %}

-- Macro to generate consistent period keys across models
-- Format: YYYY-MM (e.g., 2024-01, 2024-12)

CONCAT(
    CAST({{ year_column }} AS STRING), 
    '-', 
    LPAD(CAST({{ period_column }} AS STRING), 2, '0')
)

{% endmacro %} 
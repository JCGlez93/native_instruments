{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    
    {%- if target.name == 'prod' and custom_schema_name is not none -%}
        {# En producción, usar nombre completo del schema #}
        {{ custom_schema_name | trim }}
        
    {%- elif target.name != 'prod' and custom_schema_name is not none -%}
        {# En desarrollo, prefijo + schema personalizado #}
        {{ default_schema }}_{{ custom_schema_name | trim }}
        
    {%- else -%}
        {# Usar schema por defecto #}
        {{ default_schema }}
        
    {%- endif -%}

{%- endmacro %} 
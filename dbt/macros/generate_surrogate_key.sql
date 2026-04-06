{% macro generate_surrogate_key(field_list) -%}
    md5(coalesce(cast({{ field_list | join(" as varchar) || '-' || cast(") }} as varchar), ''))
{%- endmacro %}

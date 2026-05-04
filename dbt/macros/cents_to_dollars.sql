{#
  Converts fractional currency values (cents) into full currency values (dollars).
  Accepts a column reference and an optional decimal rounding resolution.
#}
{% macro cents_to_dollars(column_name, decimal_places=2) -%}
    round(cast({{ column_name }} as numeric) / 100, {{ decimal_places }})
{%- endmacro %}

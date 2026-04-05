{% macro safe_divide(numerator, denominator, alternate_value=0) -%}
    case 
        when {{ denominator }} = 0 then {{ alternate_value }}
        else {{ numerator }} / {{ denominator }}
    end
{%- endmacro %}

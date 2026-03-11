{% macro safe_divide(numerator, denominator) %}
    safe_divide(cast({{ numerator }} as numeric), nullif(cast({{ denominator }} as numeric), 0))
{% endmacro %}

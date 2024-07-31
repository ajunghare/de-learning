{% test starts_with(model,column_name,prefix) %}

    {# this assumes all column_name values should start with given prefix#}
select * from 
{{ model }} where not ({{ column_name }} like '{{ prefix }}%')
limit 1
{# adding limit to fetch all data  #}

{% endtest %}

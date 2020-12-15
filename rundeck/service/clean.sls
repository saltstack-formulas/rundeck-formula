# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if rundeck.service.managed == True %}

include:
  - {{ sls_config_clean }}

rundeck-service-clean-service-dead:
  service.dead:
    - name: {{ rundeck.service.name }}
    - enable: False
    - watch:
      - sls: {{ sls_config_clean }}
    - require_in:
      - sls: {{ sls_config_clean }}

    {%- endif %}

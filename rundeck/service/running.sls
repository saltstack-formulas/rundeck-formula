# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_files = tplroot ~ '.config.files' %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if rundeck.service.managed == True %}

include:
  - {{ sls_config_files }}

rundeck-service-running-service-running:
  service.running:
    - name: {{ rundeck.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_files }}

    {%- endif %}

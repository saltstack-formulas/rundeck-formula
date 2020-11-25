# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

rundeck-service-clean-service-dead:
  service.dead:
    - name: {{ rundeck.service.name }}
    - enable: False

# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

rundeck-plugin-clean:
  file.absent:
    - name: {{ rundeck.dir.lib }}/libext

# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if rundeck.pkg.use_upstream|lower in ('repo', 'package') %}

rundeck-package-repo-absent:
  pkgrepo.absent:
    - name: {{ rundeck.pkg.repo.name }}

    {%- endif %}

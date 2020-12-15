# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if 'repo' in rundeck.pkg and rundeck.pkg.repo %}
        {%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

rundeck-package-repo-managed:
  pkgrepo.managed:
    {{- format_kwargs(rundeck.pkg.repo) }}
    - humanname: {{ grains["os"] }} {{ grains["oscodename"]|capitalize }} rundeck Package Repository
    - refesh: {{ rundeck.misc.refresh }}

    {%- endif %}

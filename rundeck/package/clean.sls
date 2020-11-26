# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if grains.os_family in ('Debian',) %}
        {%- set sls_repo_clean = tplroot ~ '.package.repo.clean' %}
include:
  - {{ sls_repo_clean }}

    {%- endif %}

rundeck-package-clean-pkg:
    {%- if rundeck.pkg.use_upstream|lower == 'war' %}
  file.absent:
    - name: {{ rundeck.pkg.path }}{{ rundeck.div }}{{ rundeck.pkg.name }}.war

    {%- elif grains.kernel|lower in ('linux', 'darwin') %}

  pkg.purged:
    - name: {{ rundeck.pkg.name }}

    {%- elif grains.kernel|lower in ('windows',) %}

  chocolatey.uninstalled:
    - name: {{ rundeck.pkg.name }}

    {%- endif %}

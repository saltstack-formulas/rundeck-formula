# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}
{%- set sls_config_users = tplroot ~ '.config.users' %}

include:
  - {{ sls_config_users }}

    {%- if grains.os_family in ('Debian',) %}
        {%- set sls_repo_install = tplroot ~ '.package.repo.install' %}
  - {{ sls_repo_install }}

    {%- endif %}
    {%- if 'deps' in rundeck.pkg and rundeck.pkg.deps %}

rundeck-package-install-deps:
  pkg.installed:
    - names: {{ rundeck.pkg.deps|json }}

    {%- endif %}
    {%- if rundeck.pkg.use_upstream|lower == 'war' %}

rundeck-package-install-file:
  file.managed:
    - name: {{ rundeck.pkg.path }}{{ rundeck.div }}{{ rundeck.pkg.name }}.war
    - source: {{ rundeck.pkg.war.source }}
    - makedirs: True
    - skip_verify: True    # using https
    - require:
      - sls: {{ sls_config_users }}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
    - recurse:
      - user
      - group
      - mode
        {%- endif %}

    {%- elif grains.kernel|lower in ('linux', 'darwin') %}

rundeck-package-install-pkg:
  pkg.installed:
        {%- if grains.os_family == 'RedHat' %}
    - sources:
      - rundeck-repo: {{ rundeck.pkg.repo.source }}
        {%- else %}
    - name: {{ rundeck.pkg.name }}
    - version: {{ rundeck.pkg.version or 'latest' }}
    - runas: {{ rundeck.identity.rootuser }}
    - reload_modules: {{ rundeck.misc.reload|default(true, true) }}
    - refresh: {{ rundeck.misc.refresh|default(true, true) }}
            {%- if grains.os|lower not in ('suse',) %}
    - hold: {{ rundeck.misc.hold|default(false, true) }}
            {%- endif %}
        {%- endif %}
        {%- if grains.os_family == 'Debian' %}
    - require:
      - pkgrepo: rundeck-package-repo-managed
        {%- endif %}

    {%- elif grains.kernel|lower in ('windows',) %}

rundeck-package-install-choco:
  chocolatey.installed:
    - name: {{ rundeck.pkg.name }}
    - force: True
    - runas: {{ rundeck.identity.rootuser }}

    {%- endif %}

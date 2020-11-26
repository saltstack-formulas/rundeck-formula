# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

include:
  - {{ sls_package_install }}

    {%- if 'plugins' in rundeck and rundeck.plugins %}

rundeck-plugin-install-dir:
  file.directory:
    - name: {{ rundeck.dir.lib }}/libext
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0755'
        {%- endif %}

        {%- for plugin, plugin_options in rundeck.plugins.items() %}
            {%- set plugin_name =  salt['file.basename'](plugin_options.source) %}

rundeck-plugin-install-{{ plugin }}:
  cmd.run:
    - name: wget {{ plugin_options.source }}
    - cwd: {{ rundeck.dir.lib }}/libext
    - creates: {{ rundeck.dir.lib }}/libext/{{ plugin_name }}
    - unless: test -e {{ rundeck.dir.lib }}/libext/{{ plugin_name }}
  file.managed:
    - name: {{ rundeck.dir.lib }}/libext/{{ plugin_name }}
    - makedirs: True
    - replace: False
            {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0755'
            {%- endif %}

        {%- endfor %}
    {%- endif %}

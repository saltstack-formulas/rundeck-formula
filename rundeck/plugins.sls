# -*- coding: utf-8 -*-
# vim: ft=sls

# state:    rundeck/plugins.sls
# author:   @dseira
# date:     2018-01-30
# version:  0.0.1
# comment:  Install rundeck plugins

{% from "rundeck/map.jinja" import rundeck_settings with context %}

{% if rundeck_settings.plugins is defined %}
{% for plugin, plugin_options in rundeck_settings.plugins.items() %}

{% set plugin_name =  salt['file.basename'](plugin_options.source) %}

rundeck.plugin.{{ plugin }}.install:
    cmd.run:
        - name: wget {{ plugin_options.source }}
        - cwd: {{ rundeck_settings.plugins_path }}
        - creates: {{ rundeck_settings.plugins_path }}/{{ plugin_name }}
        - unless: test -e {{ rundeck_settings.plugins_path }}/{{ plugin_name }}

rundeck.plugin.{{ plugin }}.permissions:
    file.managed:
        - name: {{ rundeck_settings.plugins_path }}/{{ plugin_name }}
        - user: {{ rundeck_settings.user }}
        - group: {{ rundeck_settings.group }}
        - mode: '644'

{% endfor %}
{% endif %}

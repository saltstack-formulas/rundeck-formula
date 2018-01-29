# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "rundeck/map.jinja" import rundeck_settings with context %}

{% if rundeck_settings.config.source_path is defined %}
{% set rundeck_config = rundeck_settings.config.source_path %}
{% else %}
{% set rundeck_config = 'salt://rundeck/files/rundeck-config.properties.jinja' %}
{% endif %}

rundeck.config:
    file.managed:
        - name: {{ rundeck_settings.rundeck_config_path }}
        - source: {{ rundeck_config }}
        - user: rundeck
        - group: rundeck
        - mode: '640'
        - template: jinja

{% if rundeck_settings.users.source_path is defined %}
{% set rundeck_realm = rundeck_settings.users.source_path %}
{% else %}
{% set rundeck_realm = 'salt://rundeck/files/realm.properties.jinja' %}
{% endif %}

rundeck.realm:
    file.managed:
        - name: {{ rundeck_settings.realm_path }}
        - source: {{ rundeck_realm }}
        - user: rundeck
        - group: rundeck
        - mode: '640'
        - template: jinja

{% if 'framework' in rundeck_settings %}
{% if rundeck_settings.framework.source_path is defined %}
{% set rundeck_framework = rundeck_settings.framework.source_path %}
{% else %}
{% set rundeck_framework = 'salt://rundeck/files/framework.properties.jinja' %}
{% endif %}

rundeck.framework:
    file.managed:
        - name: {{ rundeck_settings.framework_path }}
        - source: {{ rundeck_framework }}
        - user: rundeck
        - group: rundeck
        - mode: '640'
        - template: jinja

{% endif %}

{% if 'profile' in rundeck_settings %}
{% if rundeck_settings.profile.source_path is defined %}
{% set rundeck_profile = rundeck_settings.profile.source_path %}
{% else %}
{% set rundeck_profile = 'salt://rundeck/files/rundeckd.jinja' %}
{% endif %}

rundeck.profile:
    file.managed:
        - name: {{ rundeck_settings.rundeckd_path }}
        - source: {{ rundeck_profile }}
        - user: rundeck
        - group: rundeck
        - mode: '640'
        - template: jinja

{% endif %}

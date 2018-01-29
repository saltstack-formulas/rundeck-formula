# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "rundeck/map.jinja" import rundeck_settings with context %}

rundeck.service:
{% if ( 'enabled' in rundeck_settings and rundeck_settings.enabled ) or ('enabled' not in rundeck_settings ) %}
    service.running:
        - name: {{ rundeck_settings.service }}
        - enable: True
        - require:
            - pkg: rundeck
        - watch:
            - file: {{ rundeck_settings.realm_path }}
            - file: {{ rundeck_settings.rundeck_config_path }}
        {% if 'framework' in rundeck_settings %}
            - file: {{ rundeck_settings.framework_path }}
        {% endif %}
        {% if 'profile' in rundeck_settings %}
            - file: {{ rundeck_settings.rundeckd_path }}
        {% endif %}
{% elif 'enabled' in rundeck_settings and not rundeck_settings.enabled %}
    service.dead:
        - name: {{ rundeck_settings.service }}
        - enable: False
{% endif %}

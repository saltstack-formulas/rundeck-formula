# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

rundeck-config-users-install-user-group-present:
  group.present:
    - name: {{ rundeck.identity.group }}
    - require_in:
      - user: rundeck-config-users-install-user-group-present
  user.present:
    - name: {{ rundeck.identity.user }}
    - groups:
      - {{ rundeck.identity.group }}
              {%- if grains.os != 'Windows' %}
    - shell: /bin/false
                  {%- if grains.kernel|lower == 'linux' %}
    - createhome: false
                  {%- elif grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ rundeck.identity.user }} >/dev/null 2>&1
                  {%- endif %}
              {%- endif %}

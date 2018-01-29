# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "rundeck/map.jinja" import rundeck_settings with context %}

{% if salt['grains.get']('os_family') == 'RedHat' %}

rundeck.repo:
    pkg.installed:
        - sources:
            - rundeck-repo: {{ rundeck_settings.repo_url }}

{% elif salt['grains.get']('os_family') == 'Debian' %}

rundeck.repo.dependencies:
    pkg.installed:
        - name: apt-transport-https

rundeck.repo:
    pkgrepo.managed:
        - name: {{ rundeck_settings.repo_url }}
        - file: /etc/apt/sources.list.d/rundeck.list
        - gpgcheck: 1
        - key_url: {{ rundeck_settings.repo_key }}

{% endif %}

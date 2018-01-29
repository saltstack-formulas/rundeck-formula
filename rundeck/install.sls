# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "rundeck/map.jinja" import rundeck_settings with context %}

rundeck.java:
    pkg.installed:
        - name: {{ rundeck_settings.pkg_java }}

rundeck.install:
    pkg.installed:
        - name: {{ rundeck_settings.pkg }}

rundeckcli.install:
    pkg.installed:
        - name: {{ rundeck_settings.pkg_cli }}

# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "rundeck/map.jinja" import rundeck_settings with context %}

include:
    - rundeck.repo
    - rundeck.install
    - rundeck.config
    - rundeck.service

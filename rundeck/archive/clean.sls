# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if grains.kernel|lower in ('linux',) %}
        {%- set sls_alternatives_clean = tplroot ~ '.software.alternatives.clean' %}

include:
  - {{ sls_alternatives_clean }}

rundeck-archive-absent:
  file.absent:
    - names:
      - {{ rundeck.dir.tmp }}/rundeck
      - {{ rundeck.pkg.path }}
        {%- if rundeck.pkg.commands and (rundeck.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS')) %}
            {%- for cmd in rundeck.pkg.commands|unique %}
      - /usr/local/bin/{{ cmd }}
            {%- endfor %}

        {%- endif %}
    {%- endif %}

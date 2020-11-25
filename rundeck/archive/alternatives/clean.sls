# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if grains.kernel == 'Linux' and rundeck.pkg.commands %}
        {%- if rundeck.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}
            {%- for cmd in rundeck.pkg.commands|unique %}

rundeck-archive-alternatives-clean-{{ cmd }}:
  alternatives.remove:
    - name: link-rundeck-{{ cmd }}
    - path: {{ rundeck.pkg.path }}/bin/{{ cmd }}
    - onlyif: update-alternatives --list |grep ^link-rundeck-{{ cmd }}

            {%- endfor %}
        {%- endif %}
    {%- endif %}

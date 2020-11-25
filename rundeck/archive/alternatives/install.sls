# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if grains.kernel == 'Linux' and rundeck.pkg.commands %}
        {%- if rundeck.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}
            {%- set sls_archive_install = tplroot ~ '.rundeck.archive.install' %}

include:
  - {{ sls_archive_install }}

            {%- for cmd in rundeck.pkg.commands|unique %}

rundeck-archive-alternatives-install-bin-{{ cmd }}:
            {%- if grains.os_family not in ('Suse', 'Arch') %}
  alternatives.install:
    - name: link-rundeck-{{ cmd }}
    - link: /usr/local/bin/{{ cmd }}
    - order: 10
    - path: {{ rundeck.pkg.path }}/{{ cmd }}
    - priority: {{ rundeck.linux.altpriority }}
                {%- else %}
  cmd.run:
    - name: update-alternatives --install /usr/local/bin/{{ cmd }} link-rundeck-{{ cmd }} {{ rundeck.pkg.path }}/{{ cmd }} {{ rundeck.linux.altpriority }} # noqa 204
                {%- endif %}
    - onlyif: test -f {{ rundeck.pkg.path }}/{{ cmd }}
    - unless: update-alternatives --list |grep ^link-rundeck-{{ cmd }} || false
    - require:
      - sls: {{ sls_archive_install }}
    - require_in:
      - alternatives: rundeck-archive-alternatives-set-bin-{{ cmd }}

rundeck-archive-alternatives-set-bin-{{ cmd }}:
  alternatives.set:
    - unless: {{ grains.os_family in ('Suse', 'Arch') }} || false
    - name: link-rundeck-{{ cmd }}
    - path: {{ rundeck.pkg.path }}/{{ cmd }}
    - onlyif: test -f {{ rundeck.pkg.path }}/{{ cmd }}

            {%- endfor %}
        {%- endif %}
    {%- endif %}

# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

    {%- if rundeck.pkg.use_upstream == 'archive' and 'archive' in rundeck.pkg %}
        {%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}
        {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

rundeck-archive-install:
        {%- if 'deps' in rundeck.pkg and rundeck.pkg.deps %}
  pkg.installed:
    - names: {{ rundeck.pkg.deps|json }}
    - reload_modules: True
    - require_in:
      - file: rundeck-archive-install
        {%- endif %}
  file.directory:
    - name: {{ rundeck.pkg.path }}
    - makedirs: True
    - require_in:
      - archive: rundeck-archive-install
        {%- if grains.os != 'Windows' %}
    - mode: 755
    - user: {{ rundeck.rootuser }}
    - group: {{ rundeck.rootgroup }}
    - recurse:
        - user
        - group
        - mode
        {%- endif %}
  archive.extracted:
    {{- format_kwargs(rundeck.pkg['archive']) }}
    - enforce_toplevel: false
    - trim_output: true
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.rootuser }}
    - group: {{ rundeck.rootgroup }}
    - recurse:
        - user
        - group
        {%- endif %}
    - require:
      - file: rundeck-archive-install

        {%- if rundeck.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS') %}
            {%- for cmd in rundeck.pkg.commands|unique %}

rundeck-archive-install-symlink-{{ cmd }}:
  file.symlink:
    - name: /usr/local/bin/{{ cmd }}
    - target: {{ rundeck.pkg.path }}/{{ cmd }}
    - force: True
    - onchanges:
      - archive: rundeck-archive-install
    - require:
      - archive: rundeck-archive-install

            {%- endfor %}
        {%- endif %}
        {%- if 'service' in rundeck.pkg and rundeck.service is mapping %}

rundeck-archive-install-file-directory:
  file.directory:
    - name: {{ rundeck.dir.lib }}
    - makedirs: True
            {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.rootuser }}
    - group: {{ rundeck.rootgroup }}
    - mode: '0755'
            {%- endif %}
            {%- if grains.kernel|lower == 'linux' %}

rundeck-archive-install-managed-service:
  file.managed:
    - name: {{ rundeck.dir.service }}/{{ rundeck.service.name }}.service
    - source: {{ files_switch(['systemrundeck.ini.jinja'],
                              lookup=formula ~ '-archive-install-managed-service'
                 )
              }}
    - makedirs: True
    - user: {{ rundeck.rootuser }}
    - mode: '0644'
    - group: {{ rundeck.rootgroup }}
    - template: jinja
    - context:
        desc: {{ rundeck.service.name }} service
        doc: 'https://github.com/salt-stack-formulas/rundeck-formula'
        name: {{ rundeck.service.name }}
        user: {{ rundeck.rootuser }}
        group: {{ rundeck.rootgroup }}
        workdir: {{ rundeck.dir.lib }}
        start: {{ rundeck.pkg.path }}/{{ rundeck.service.name }}
        stop: /usr/bin/env killall -qr '{{ rundeck.pkg.path }}/{{ rundeck.service.name }}'
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - archive: rundeck-archive-install

            {%- endif %}
        {%- else %}

rundeck-archive-install-show-notification:
  test.show_notification:
    - text: |
        The rundeck archive is unavailable/unselected for {{ salt['grains.get']('finger', grains.os_family) }}

        {%- endif %}
    {%- endif %}

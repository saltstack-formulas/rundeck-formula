# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}

include:
  - {{ sls_package_clean }}

rundeck-config-files-config-clean:
  file.absent:
    - names:
      - {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.config }}
      - {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.realm }}
      - {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.framework }}
      - {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.profile }}
      - {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.login }}
    - require:
      - sls: {{ sls_package_clean }}

    {%- if 'sshkey' in rundeck and rundeck.sshkey is mapping %}
        {% for dir,dir_options in rundeck.sshkey.items() %}

rundeck-config-files-sshkey-{{ dir }}-clean:
  file.absent:
    - name: {{ dir }}
    - require:
      - sls: {{ sls_package_clean }}

        {%- endfor %}
    {%- endif %}

rundeck-config-users-config-clean:
  user.absent:
    - name: {{ rundeck.identity.user }}
    - require:
      - sls: {{ sls_package_clean }}
  group.absent:
    - name: {{ rundeck.identity.user }}
    - require:
      - user: rundeck-config-users-config-clean

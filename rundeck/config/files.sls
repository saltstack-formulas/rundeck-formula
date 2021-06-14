# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import rundeck with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

rundeck-config-files-config-managed:
  file.managed:
    - name: {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.config }}
        {%- if 'source_path' in rundeck.config and rundeck.config.source_path %}
    - source: {{ rundeck.config.source_path }}
        {%- else %}
    - source: {{ files_switch(['config.properties.jinja'],
                              lookup='rundeck-config-files-config-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config: {{ rundeck.config|json }}

    {%- if rundeck.pkg.use_upstream|lower == 'war' %}

rundeck-config-files-webapp-managed:
  file.managed:
    - name: {{ rundeck.dir.tomcat }}{{ rundeck.div }}setenv.sh
        {%- if 'source_path' in rundeck.pkg.war and rundeck.pkg.war.source_path %}
    - source: {{ rundeck.pkg.war.source_path }}
        {%- else %}
    - source: {{ files_switch(['setenv.sh.jinja'],
                              lookup='rundeck-config-files-webapp-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0755'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        javaopts: {{ rundeck.pkg.war.javaopts }}
        mx_perm_sz: {{ rundeck.pkg.war.mx_perm_sz }}
        mx: {{ rundeck.pkg.war.mx }}
        ms: {{ rundeck.pkg.war.ms }}
        basedir: {{ rundeck.pkg.path }}
        config: {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.config }}
        logdir: {{ rundeck.pkg.path }}{{ rundeck.div }}{{ rundeck.dir.log }}

    {%- endif %}
    {%- if 'realm' in rundeck and rundeck.realm %}

rundeck-config-files-realm-managed:
  file.managed:
    - name: {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.realm }}
        {%- if 'source_path' in rundeck.realm and rundeck.realm.source_path %}
    - source: {{ rundeck.realm.source_path }}
        {%- else %}
    - source: {{ files_switch(['realm.properties.jinja'],
                              lookup='rundeck-config-files-realm-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config: {{ rundeck.realm|json }}

    {%- endif %}
    {%- if 'framework' in rundeck and rundeck.framework %}

rundeck-config-files-framework-managed:
  file.managed:
    - name: {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.framework }}
        {%- if 'source_path' in rundeck.framework and rundeck.framework.source_path %}
    - source: {{ rundeck.framework.source_path }}
        {%- else %}
    - source: {{ files_switch(['framework.properties.jinja'],
                              lookup='rundeck-config-files-framework-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config: {{ rundeck.framework|json }}

    {%- endif %}
    {%- if 'profile' in rundeck and rundeck.profile %}

rundeck-config-files-profile-managed:
  file.managed:
    - name: {{ rundeck.dir.profile }}{{ rundeck.div }}{{ rundeck.configfile.profile }}
        {%- if 'source_path' in rundeck.profile and rundeck.profile.source_path %}
    - source: {{ rundeck.profile.source_path }}
        {%- else %}
    - source: {{ files_switch(['rundeckd.jinja'],
                              lookup='rundeck-config-files-profile-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config: {{ rundeck.profile|json }}

    {%- endif %}
    {%- if 'login' in rundeck and rundeck.login %}

rundeck-config-files-login-managed:
  file.managed:
    - name: {{ rundeck.dir.config }}{{ rundeck.div }}{{ rundeck.configfile.login }}
        {%- if 'source_path' in rundeck.login and rundeck.login.source_path %}
    - source: {{ rundeck.login.source_path }}
        {%- else %}
    - source: {{ files_switch(['jaas.conf.jinja'],
                              lookup='rundeck-config-files-login-managed'
                 )
              }}
        {%- endif %}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        config: {{ rundeck.login|json }}

    {%- endif %}
    {%- if 'sshkey' in rundeck and rundeck.sshkey %}
        {% for dir,dir_options in rundeck.sshkey.items() %}

rundeck-config-files-sshkey-{{ dir }}-dir:
  file.directory:
    - name: {{ dir }}
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0750'
        {%- endif %}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}

rundeck-config-files-sshkey-{{dir }}.private_key:
  file.managed:
    - name: {{ dir }}/id_rsa
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0600'
        {%- endif %}
    - makedirs: True
    - contents_pillar: rundeck:sshkey:{{ dir }}:private
    - require:
      - file: rundeck-config-files-sshkey-{{ dir }}-dir

rundeck-config-files-sshkey-{{dir }}.public_key:
  file.managed:
    - name: {{ dir }}/id_rsa.pub
        {%- if grains.os != 'Windows' %}
    - user: {{ rundeck.identity.user }}
    - group: {{ rundeck.identity.group }}
    - mode: '0640'
        {%- endif %}
    - makedirs: True
    - contents_pillar: rundeck:sshkey:{{ dir }}:public
    - require:
      - file: rundeck-config-files-sshkey-{{dir }}.private_key

        {%- endfor %}
    {%- endif %}

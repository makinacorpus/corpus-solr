{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% set fv = cfg.data.fv %}
{% set sdata = salt['mc_utils.json_dump'](data) %}
jetty-conf:
  file.recurse:
    - include_empty: true
    - include_pat: '*'
    - source: "{{data.jetty_conf}}"
    - name: {{data.jetty}}
    - makedirs: true
    - template: jinja
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - dir_mode: 0770
    - file_mode: 0660
    - defaults:
        project: "{{cfg.name}}"

solr-global_conf:
  file.recurse:
    - include_empty: true
    - include_pat: '*'
    - source: "{{data.solr_conf}}"
    - name: {{data.sdata}}
    - makedirs: true
    - template: jinja
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - dir_mode: 0770
    - file_mode: 0660
    - defaults:
        project: "{{cfg.name}}"

{% for core_data in data.cores %}
{% for core_name, core_conf in core_data.items() %}
solr-core-{{core_name}}:
  file.recurse:
    - include_empty: true
    - include_pat: '*'
    - force: true
    - source: "{{core_conf}}"
    - name: "{{data.sdata}}/{{core_name}}/conf"
    - makedirs: true
    - template: jinja
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - dir_mode: 0770
    - file_mode: 0660
    - defaults:
        project: "{{cfg.name}}"
        core: "{{core_name}}"
{% endfor %}
{% endfor %}

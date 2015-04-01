{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
include:
  - makina-states.localsettings.jdk

{% set version = data.version %}
{% set fv = data.fv %}

solr-{{ version }}:
  file.directory:
    - names:
      - {{ data.sroot }}
      - {{ data.sdata }}
{% for core_data in data.cores %}
{% for core_name, core_conf in core_data.items() %}
      - {{ data.sdata }}/{{core_name}}/conf
      - {{ data.sdata }}/{{core_name}}/data
{% endfor %}
{% endfor %}
    - makedirs: true
    - user: {{cfg.user}}
  cmd.run:
    - user: {{cfg.user}}
    - watch:
      - file: solr-{{version}}
    - require_in:
      - file: {{cfg.name}}-solr-extra-libs
    - cwd: {{ data.sroot}}
    - onlyif: test ! -e '{{ data.sroot}}/solr-{{ fv }}-download'
    - name: >
            wget -c http://mirror.metrocast.net/apache/lucene/solr/{{ fv }}/solr-{{ fv }}.tgz &&
            tar xzf solr-{{ fv }}.tgz && touch solr-{{ fv }}-download


{% for i in data.bundle_sync %}
solr-jetty-bundle-{{i}}:
  cmd.run:
    - require:
      - cmd: solr-{{ version }}
    - name: |
            rsync -Aa \
              "{{ data.sroot}}/solr-{{fv}}/example/{{i}}" \
               "{{data.jetty}}/{{i}}"
    - require_in:
      - file: {{cfg.name}}-solr-extra-libs
    - user: {{cfg.user}}
{% endfor %}

{% for i in data.bundle_top_sync %}
solr-dist-top-conf-{{i}}:
  file.symlink:
    - name: {{data.sroot}}/{{i}}
    - require:
      - cmd: solr-{{ version }}
    - require_in:
      - file: {{cfg.name}}-solr-extra-libs
    - target: "{{ data.sroot}}/solr-{{fv}}/{{i}}"
{% endfor %}

{{cfg.name}}-solr-extra-libs:
  file.recurse:
    - source: salt://makina-projects/{{cfg.name}}/files/lib/
    - name: {{data.jetty}}/lib
    - include_empty: true
    - include_pat: '*'
    - clean: false
    - force: true
    - makedirs: true
    - template: jinja
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - dir_mode: 0770
    - file_mode: 0660
    - defaults:
        project: "{{cfg.name}}"

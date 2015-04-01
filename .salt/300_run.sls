{% import "makina-states/services/monitoring/circus/macros.jinja" as circus  with context %}
{% import "makina-states/services/http/nginx/init.sls" as nginx %}
{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
include:
  - makina-states.services.monitoring.circus
  - makina-states.services.http.nginx

echo restart:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-restart-hook
      - mc_proxy: circus-pre-restart

{% set circus_data = {
     'cmd': data.start_cmd.format(*data.start_args),
     'uid': cfg.user,
     'gid': cfg.group,
     'copy_env': True,
     'working_dir': data.jetty,
     'warmup_delay': "30",
     'max_age': 24*60*60} %}
{{ circus.circusAddWatcher(cfg.name, **circus_data) }}
{{ nginx.virtualhost(
      domain=data.domain,
      cfg=cfg,
      vhost_basename="solr-"+cfg.name,
      vh_top_source=data.nginx_upstream,
      vh_content_source=data.nginx_vhost) }}

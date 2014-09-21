

corpus-solr-sav-project-dir:
  cmd.run:
    - name: |
            if [ ! -d "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project" ];then
              mkdir -p "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project";
            fi;
            rsync -Aa --delete "/srv/projects/corpus-solr/project/" "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project/"
    - user: root

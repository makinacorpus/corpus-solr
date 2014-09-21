


corpus-solr-rollback-faileproject-dir:
  cmd.run:
    - name: |
            if [ -d "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project" ];then
              rsync -Aa --delete "/srv/projects/corpus-solr/project/" "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project.failed/"
            fi;
    - user: corpus-solr-user

corpus-solr-rollback-project-dir:
  cmd.run:
    - name: |
            if [ -d "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project" ];then
              rsync -Aa --delete "/srv/projects/corpus-solr/archives/2014-09-21_16_38-30_730e7ade-f491-4ede-93fd-afedd7d54f8f/project/" "/srv/projects/corpus-solr/project/"
            fi;
    - user: corpus-solr-user
    - require:
      - cmd:  corpus-solr-rollback-faileproject-dir

root = "/home/deployer/apps/survey-site/current"
working_directory root
pid "#{root}/tmp/pids/unicorn_survey-site.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.survey-site.sock"
worker_processes 2
timeout 30
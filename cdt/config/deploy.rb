#
# Put here shared configuration shared among all children
#
# Read more about configurations:
# https://github.com/railsware/capistrano-multiconfig/blob/master/README.md

#ask :branch, 'master'
set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :application, proc { fetch(:stage).to_s.split(':').reverse[1] }

set :repo_url, proc { "git@github.com:me/#{fetch(:application)}.git" }

set :deploy_to, proc { "/var/www/#{fetch(:application)}" }

set :scm, :git

set :format, :pretty

set :log_level, :error

set :pty, true

set :use_sudo, false

set :ssh_options, {
  forward_agent: true
}

set :document_root, ""

set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 1

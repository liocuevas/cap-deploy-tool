############################################
# Setup Server
############################################

set :stage, :production

set :stage_url, "http://www.example.com"
server "127.0.0.0", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/path/to/folder"
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"
set :keep_releases, 2

############################################
# Setup Git
############################################

load 'lib/submodule_strategy.rb'
set :repo_url, "GIT REPO URL"
set :git_strategy, SubmoduleStrategy
set :repo_link, "HTTPS REPO URL"
set :branch, "master"

############################################
# Setup Hipchat
############################################

set :hipchat_app_name, "REPO NAME"
set :hipchat_room, "My Room"

############################################
# Setup WP Deploy Tasks
############################################

set :app_wp_name, 'REPO NAME'
set :wp_table_prefix, 'wp_'
set :linked_files, %w{wp-config.php .htaccess}
set :linked_dirs, %w{content/uploads}

namespace :deploy do

  desc "create WordPress files for symlinking"
  task :create_wp_files do
    on roles(:app) do
      invoke 'wp:generate_remote_files'
      execute :touch, "#{shared_path}/wp-config.php"
      execute :touch, "#{shared_path}/.htaccess"
    end
  end

  after 'check:make_linked_dirs', :create_wp_files
end

############################################
# Run tasks at the end of the deploy
############################################

after "deploy:finished", "cdt:send_hipchat_message"
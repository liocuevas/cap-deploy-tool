############################################
# Setup Server
############################################

set :stage, :staging

set :stage_url, "http://www.example.com"
server "127.0.0.0", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/path/to/folder"
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"
# set :document_root, "build" ### PATH to DOCUMENT ROOT

############################################
# Setup Git
############################################

set :repo_url, "GIT REPO URL"
set :repo_link, "HTTPS REPO URL"
set :branch, "development"

############################################
# Setup Hipchat Message
############################################

set :hipchat_app_name, "REPO NAME"
set :hipchat_room, "My Room"


############################################
# Run tasks at the end of the deploy
############################################

before "deploy:finished", "cdt:create_robots"
after "deploy:finished", "cdt:send_hipchat_message"
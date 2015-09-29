Cap Deploy Tool
======
Deploy applications with caphub, capistrano and webhooks

## Install

* Clone this repository `git clone https://github.com/liocuevas/cap-deploy-tool.git`
* Run:

``` bash
cd path/to/deploy
npm install
bundle install
cd cdt
bundle install
```

## Setup repositories to listen

* Edit `deploys.json` file and add the Github repositories to listen
``` json
{
    "deploys": [{
        "name": "Your deploy name",
        "type": "github",
        "repo": "[the repo url in https format, example https://github.com/owner/repo-name]",
        "basepath": "[path to where the deploy command will run]",
        "command": "bundle exec cap project-name:staging deploy",
        "branch": "[what branch to react to]"
    }]
}
```

* Edit `gitlab.json` file and add the Gitlab repositories to listen
``` json
{
    "host" : "0.0.0.0",
    "port" : 8889,
    "repositories" : {
        "[repository name]" : {
            "name":"[my super cool name]",
            "basepath" : "[path to where the command will run]",
            "command" : "bundle exec cap project-name:staging deploy",
            "branch" : "[what branch to react to]"
        }
    }
}
```

* Edit `bitbucket.json` file and add the Bitbucket repositories to listen
``` json
{    
    "port" : 8989,
    "repositories" : {
        "[repository name]" : {
            "name":"[my super cool name]",
            "basepath" : "[path to where the command will run]",
            "command" : "bundle exec cap project-name:staging deploy",
            "branch" : "[what branch to react to]"
        }
    }
}
```

## Setup capistrano deploy files

* Create inside `cdt/config/deploy` a folder with the project name and inside the folder the staging.rb and production.rb
  (if the project is a wp-deploy https://github.com/Mixd/wp-deploy you will need to create an additional file named database.yml)

### Example staging.rb
``` ruby
############################################
#Setup Server
############################################

set :stage, :staging

set :stage_url, "http://test.com"
server "host", user: "ssh_user", roles: %w{web app db}
set :deploy_to, "/path/to/folder"
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"

############################################
# Setup Git
############################################

set :repo_url, "repo ssh url"
set :repo_link, "repository link"
set :branch, "develop"

############################################
# Setup Hipchat
############################################

set :hipchat_room, "Default Hipchat Room"

############################################
# Run tasks at the end of the deploy
############################################

before "deploy:finished", "cdt:create_robots"
after "deploy:finished", "cdt:send_hipchat_message"

```
### Example staging.rb for WP DEPLOY
``` ruby
############################################
#Setup Server
############################################

set :stage, :staging

set :stage_url, "http://test.com"
server "host", user: "ssh_user", roles: %w{web app db}
set :deploy_to, "/path/to/folder"
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"

############################################
# Setup Git
############################################

load 'lib/submodule_strategy.rb'
set :git_strategy, SubmoduleStrategy
set :repo_url, "repo ssh url"
set :repo_link, "repository link"
set :branch, "development"

############################################
# Setup Hipchat
############################################

set :hipchat_room, "Default Hipchat Room"

############################################
# Setup WP Deploy Tasks
############################################

set :app_wp_name, 'my-app-name'
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

before "deploy:finished", "cdt:create_robots"
after "deploy:finished", "cdt:send_hipchat_message"

```

#### Example database.yml

* Copy the example file from `cdt/config/database.yml.example` to cdt/config/deploy/YOUR_APP_NAME/database.yml 

``` yaml
staging:
  host: localhost
  database: db_name
  username: db_user
  password: 'root'
production:
  host: localhost
  database: db_name
  username: db_user
  password: 'root'
local:
  host: localhost
  database: db_name
  username: db_user
  password: 'root'
```

## Available Commands

* Inside `cdt/` you can run manually the tasks from the command-line
  * `cap -T`: List the available tasks  
  * `bundle exec cap project-name:stage-name deploy [options] ex --trace`

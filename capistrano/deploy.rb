
set :user, "SSH USERNAME"
set :application, "APPNAME"
set(:deploy_to) { File.join("", "home", user, application) }

set :scm, :git
set :repository,  "REPOADDRESS"
set :branch, "master"
set :deploy_via, :remote_cache

set :domain, "APPDOMAIN"
set :domain_aliases, "DOMAIN ALIASES"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "APP SERVER 1", :app, :web, :db, :primary => true
server "APP SERVER 2", :app, :web

namespace :apache do
  
    desc "Configure VHost"
    task :config_vhost do
      vhost_config =<<-EOF
  <VirtualHost *:80>
  ServerName #{domain}
  ServerAlias #{domain_aliases}
  DocumentRoot #{deploy_to}/current/_site
  CustomLog #{shared_path}/log/access.log common
  ErrorLog #{shared_path}/log/error.log
  <Directory "#{deploy_to}/current/_site">
  Options FollowSymLinks
  AllowOverride All
  Order allow,deny
  Allow from all
  </Directory>
  </VirtualHost>
  EOF
     put vhost_config, "vhost_config"
     sudo "mv vhost_config /etc/apache2/sites-available/jekyll-#{application}"
     sudo "a2ensite jekyll-#{application}"
    end
    
  desc "Enable Site"
    task :enable_vhost do
    sudo "a2ensite jekyll-#{application}"
  end
   
  desc "Reload Apache"
    task :reload do
    sudo "/etc/init.d/apache2 reload"
  end

end


after "deploy:update_code" do
  run "mv #{latest_release}/htaccess #{latest_release}/.htaccess"
  run "mv #{latest_release}/_config_live.yml #{latest_release}/_config.yml"
  run "cd #{latest_release} && jekyll"
end

#after "deploy:setup"
after "deploy:update_code", "apache:config_vhost", "apache:reload"
#after "apache:config_vhost"

deploy.task :restart do
end

deploy.task :finalize_update do
end
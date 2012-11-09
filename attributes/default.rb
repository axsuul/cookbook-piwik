default['piwik']['version'] = "1.9.1"
default['piwik']['install_path'] = "/srv/piwik"

default['piwik']['php_fastcgi_pass'] = "127.0.0.1:9000"

# Potentially support other web servers in the future (i.e. apache, lighttpd)
default['piwik']['server'] = "nginx"
default['piwik']['server_host'] = "stats.*"   # Public url root

# Hard-coded with MySQL for now
default['piwik']['database_host'] = default['mysql']['bind_address']
default['piwik']['database_port'] = default['mysql']['port']
default['piwik']['database_name'] = "piwik"
default['piwik']['database_user'] = "piwik"
default['piwik']['database_password'] = "piwik"
include_recipe "mysql::server"
include_recipe "mysql::ruby"

# Install PHP
%w(php5-cgi php5-cli php5 php5-gd php5-mysql).each {|pkg| package pkg }

# Create database
db_connection = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database_user node['piwik']['database_user'] do
    connection db_connection
    password node['piwik']['database_password']
    privileges [:create, :alter, :select, :insert, :update, :delete, :drop, "create temporary tables"]
    action :grant
  end

mysql_database node['piwik']['database_name'] do
  connection db_connection
  owner node['piwik']['database_user']
  action :create
end

# Drop web server config
case node['piwik']['server']
when "nginx"
  server_user = node['nginx']['user']
  include_recipe "nginx::source"
  include_recipe "piwik::nginx"
end

# Install piwik
version = node['piwik']['version']
install_path = node['piwik']['install_path']
tar_file = "piwik-#{version}.tar.gz"

# NOTE: remote_file will uncompress to tar
remote_file "#{Chef::Config[:file_cache_path]}/#{tar_file}" do
  source "http://builds.piwik.org/piwik-#{version}.tar"
  mode 0644
  action :create_if_missing
end

# Create directory
directory install_path do
  mode 0755
  owner server_user
  action :create
end

bash "Extract #{tar_file}" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xvf #{tar_file}
    cd piwik
    mv * #{install_path}
    echo '#{version}' > #{install_path}/VERSION
  EOH
  not_if "test `cat #{install_path}/VERSION` = #{version}"
end


# Piwik needs these permissions to properly run
[
  "#{install_path}/tmp",
  "#{install_path}/tmp/templates_c",
  "#{install_path}/tmp/cache",
  "#{install_path}/tmp/assets",
  "#{install_path}/tmp/tcpdf",
  "#{install_path}/tmp/config"
].each do |dir|
  directory dir do
    mode 0777
    owner server_user
    action :create
    recursive true
  end
end
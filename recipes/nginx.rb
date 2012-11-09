sites_available = "#{node['nginx']['dir']}/sites-available"
sites_enabled = "#{node['nginx']['dir']}/sites-enabled"

template "#{sites_available}/piwik" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0644
end

link "#{sites_enabled}/piwik" do
  to "#{sites_available}/piwik"
end
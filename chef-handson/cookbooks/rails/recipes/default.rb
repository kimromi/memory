#
# Cookbook Name:: rails
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
include_recipe 'yum-epel'

# nginx
package 'nginx' do
  action :install
end
service 'nginx' do
  action [:enable, :start]
end

# for Rails
directory '/var/www/rails' do
  mode '775'
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

# for sqlite3
package 'sqlite-devel'

# for uglifier
remote_file "#{Chef::Config[:file_cache_path]}/http-parser-2.7.1-3.el7.x86_64.rpm" do
  source "https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm"
  not_if "rpm -qa | grep -q '^http-parser'"
  action :create
  notifies :install, "rpm_package[http-parser]", :immediately
end
rpm_package "http-parser" do
  source "#{Chef::Config[:file_cache_path]}/http-parser-2.7.1-3.el7.x86_64.rpm"
  action :nothing
end
package 'nodejs'

# chef1.exapmle用のnginx設定
template "/etc/nginx/conf.d/chef1.example.conf" do
  source 'chef1.example.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end


#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum-epel'

package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end

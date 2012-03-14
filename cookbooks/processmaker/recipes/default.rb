#
# Cookbook Name:: processmaker
# Recipe:: default
#
# Copyright 2012, Nathan Mische
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# install packages

include_recipe "processmaker::package"

# download and extract the processmaker installer

remote_file "#{Chef::Config['file_cache_path']}/processmaker-2.0.38.tar.gz" do
  source "http://sourceforge.net/projects/processmaker/files/ProcessMaker/2.0/2.0.38/processmaker-2.0.38.tar.gz/download"
  action :create_if_missing
  mode "0744"
  owner "root"
  group "root"
end

execute "extract_pmos" do
  command "tar --directory /opt -xzvf #{Chef::Config['file_cache_path']}/processmaker-2.0.38.tar.gz"
  creates "/opt/processmaker"
  action :run
  user "root"
  cwd "#{Chef::Config['file_cache_path']}"
end

# set up directories and permissions 

directory "/opt/processmaker/compiled" do
  owner "www-data"
  group "www-data"
  mode "0777"
  action :create
end

directory "/opt/processmaker/shared" do
  mode "0777"
end

dirs = ["config", "content/languages", "plugins", "xmlform", "js/labels"]

dirs.each do|d|
	directory "/opt/processmaker/workflow/engine/#{d}" do
  		mode "0777"
	end  
end

directory "/opt/processmaker" do
	owner "www-data"
	group "www-data"
	recursive true
end

# configure apache

apache_module "expires"
apache_module "rewrite"
apache_module "deflate"
apache_module "vhost_alias"

web_app "pmos" do
  server_name "33.33.33.123"
  server_aliases [node['fqdn'], "my-pmos"]
end
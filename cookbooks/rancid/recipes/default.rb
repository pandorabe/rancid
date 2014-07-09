#
# Cookbook Name:: rancid
# Recipe:: default
#
#

# RANCID install
%w{rancid cvs rcs httpd viewvc mod_python cronie telnet}.each do |p|
  yum_package p do
    action :install
  end
end

template "rancid.conf" do
  path "/etc/rancid/rancid.conf"
  source "rancid.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "httpd.viewvc.conf" do
  path "/etc/httpd/conf.d/viewvc.conf"
  source "httpd.viewvc.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

script "mailaliases_viewvc" do
  interpreter "bash"
  user "root"
  code <<-EOL
  echo "rancid-notify:   rancid-admin-notify" >> /etc/aliases
  echo "rancid-admin-notify:    #{node['rancid']['mailsender']} " >> /etc/aliases
  newaliases
  echo "cvs_roots = rancid: /var/rancid/CVS" >> /etc/viewvc/viewvc.conf
  echo "default_root = rancid" >> /etc/viewvc/viewvc.conf
  EOL
end

script "rancid-cvs" do
  interpreter "bash"
  user "rancid"
  environment (
    {'HOME' => '/var/rancid', 'USER' => 'rancid'}
  )
  code <<-EOL
  cd /var/rancid
  rancid-cvs
  touch .cloginrc
  chmod 600 .cloginrc
  EOL
end

cookbook_file "/usr/libexec/rancid/yrancid" do
  source "yrancid"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/usr/libexec/rancid/ylogin" do
  source "ylogin"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/usr/libexec/rancid/rancid-fe" do
  source "rancid-fe"
  owner "root"
  group "root"
  mode "0755"
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end


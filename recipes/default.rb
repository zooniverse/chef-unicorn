gem_package 'unicorn' do
  version node['unicorn']['version'] 
end

directory '/usr/local/unicorn' do
  owner 'root'
  group 'root'
  action :create
  mode '775'
end

template_variables = {
  name: node['unicorn']['site']['name'],
  app_path: node['unicorn']['site']['app_path'],
  pid_path: "/var/run/unicorn.#{ node['unicorn']['site']['name'] }.pid",
  config_path: "/usr/local/unicorn/#{ node['unicorn']['site']['name'] }.rb",
  environment: node['unicorn']['site']['environment'],
  workers: node['unicorn']['site']['workers'],
  timeout: node['unicorn']['site']['timeout'],
  max_memory: node['unicorn']['site']['max_memory'],
  user: node['unicorn']['user'],
  group: node['unicorn']['group']
}

template "/usr/local/unicorn/#{ node['unicorn']['site']['name']}.rb" do
  source "#{ node['unicorn']['site']['config'] }.rb.erb"
  owner 'root'
  group 'root'
  mode '755'
  variables template_variables
end

template "/etc/init.d/#{ node['unicorn']['site']['name'].downcase }" do
  source 'init.sh.erb'
  owner 'root'
  group 'root'
  mode '755'
  variables template_variables
end

service node['unicorn']['site']['name'].downcase do
  supports restart: true, reload: true
  action [:enable]
end

if node.chef_environment == 'production'
  template "/etc/monit/conf.d/#{ node['unicorn']['site']['name'] }.monitrc" do
    owner 'root'
    group 'root'
    mode  0644
    source 'unicorn.monitrc.erb'
    variables template_variables
    
    notifies :run, resources(execute: 'restart-monit')
  end
end

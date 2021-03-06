default['unicorn']['version'] = '4.7.0'
default['unicorn']['user'] = 'www-data'
default['unicorn']['group'] = 'www-data'
default['unicorn']['site']['config'] = 'default'
default['unicorn']['site']['environment'] = 'development'
default['unicorn']['site']['workers'] = 4
default['unicorn']['site']['timeout'] = 10
default['unicorn']['site']['max_memory'] = 1400
default['unicorn']['site']['config_path'] = "/usr/local/unicorn/#{ node['unicorn']['site']['name'] }.rb"
default['unicorn']['site']['app_path'] = "/rails/apps/#{ node['unicorn']['site']['name'] }/current"
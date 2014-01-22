require 'spec_helper'

describe 'unicorn::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['unicorn']['site']['name'] = 'test_site'
    end.converge(described_recipe)
  end

  it 'should create the /usr/local/unicorn directory' do
    expect(chef_run).to create_directory('/usr/local/unicorn')
      .with(
        user: 'root',
        group: 'root',
        mode: '775'
      )
  end

  it 'should create an init file' do
    expect(chef_run).to render_file("/etc/init.d/test_site")
  end

  it 'should create a unicorn configuration file' do
    expect(chef_run).to render_file("/usr/local/unicorn/test_site.rb")
  end

  it 'should enable the site service' do
    expect(chef_run).to enable_service('test_site')
  end
end

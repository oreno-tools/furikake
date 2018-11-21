require 'spec_helper'

describe 'Frikake::Resource' do
  before do
    allow(Furikake::Resource).to receive(:load_config_resource_type).and_return(['test1', 'test2', 'test3'])
    allow(Furikake::Resource).to receive(:load_default_resource_type).and_return(['test1', 'test2', 'test3'])
    allow(Furikake::Resource).to receive(:load_addons_resource_type).and_return(['test4', 'test5'])
  end

  # after do
  #   File.delete('spec/tmp/furikake.yml.test')
  # end

  it 'check load_resource_type' do
    actual = Furikake::Resource.load_resource_type
    expect = ['test1', 'test2', 'test3', 'test4', 'test5']
    expect(expect).to eq(actual)
  end

  it 'check load_config_resource_type' do
      yaml_contents = <<"EOS"
resources:
  aws:
    - test1
    - test2
    - test3
  projects:
    - space_id: 'your-backlog-space-id'
      api_key: 'your-backlog-api-key'
      top_level_domain: 'your-backlog-top-level-domain'
      wiki_id: your-wiki-id
      wiki_name: 'your-wiki-name'
      header: >
        # Test Header

        [toc]

        ## Sub Header
      footer: >
        ## Test Footer

        ### Sub Footer
EOS
    erb = ERB.new(yaml_contents, nil, '-')
    File.open('spec/tmp/furikake.yml.test', 'w') do |f|
      f.write(erb.result(binding))
    end
    actual = Furikake::Resource.load_config_resource_type('spec/tmp/furikake.yml.test')
    expect = ['test1', 'test2', 'test3']
    expect(expect).to eq(actual)
  end
end

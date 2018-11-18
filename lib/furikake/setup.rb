module Furikake
  class Setup
    def self.run
      puts '[setup] creating .furikake.yml...'
      create_furikake_yaml unless File.exist?('.furikake.yml')
      puts '[setup] .furikake.yml already exists.'
      exit
    end

    def self.create_furikake_yaml
      resource_type = Furikake::Resource.load_type
      yaml_contents = <<"EOS"
resources:
  aws:
<%- resource_type.each do |r| -%>
    - <%= r %>
<%- end -%>backlog:
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
      File.open('.furikake.yml', 'w') do |f|
        f.write(erb.result(binding))
      end
      puts '[setup] .furikake.yml created.'
      exit
    end
  end
end

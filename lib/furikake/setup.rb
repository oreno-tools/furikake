module Furikake
  class Setup
    def self.run
      puts '[setup] creating .furikake.yml...'
      create_furikake_yaml unless File.exist?('.furikake.yml')
      puts '[setup] .furikake.yml already exists.'
      setup_addons
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

    def self.setup_addons
      puts '[setup] create `addons` directory? [y/n]'
      response = STDIN.gets.chomp
      case response
      when /^[yY]/
        self.create_addons_directory unless FileTest.exist?('addons')
        puts '[setup] `addons` directory already exists.'
        exit
      when /^[nN]/, /^$/
        puts '[setup] `addons` directory not created.'
        exit 0
      else
        puts 'Please input y(Y) or n(N)'
        setup_addons
      end
    end

    def self.create_addons_directory
      puts '[setup] creating `addons` directory.'
      FileUtils.mkdir_p('addons')
      f = File.open('addons/furikake-resource-addon-example.rb', 'w')
      f.print <<EOS
module Furikake::Resources
  module Addons
    class Example
      def self.report(format = nil)
        values = [['value1', 'value2'], ['value3', 'value4']]
        contents = {
          title: 'Example',
          resources: [
            {
               subtitle: '',
               header: ['Title1', 'Title2'],
               resource: values
            }
          ]
        }
        Furikake::Formatter.shaping(format, contents)
      end

      def self.get_resources
        ... Please implement ...
      end
    end
  end
end
EOS
      puts '[setup] `addons` directory created.'
      exit
    end
  end
end

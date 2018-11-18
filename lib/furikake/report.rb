require 'furikake/reporters/backlog'

module Furikake
  class Report
    include Furikake::Config

    def initialize
      @params = read_furikake_yaml
      @resource = Furikake::Resource.generate
    end

    def show
      @params['backlog']['projects'].each do |p|
        header = insert_published_by(p['header'])
        footer = p['footer']
        puts generate(header, footer)
      end
    end

    def publish
      @params['backlog']['projects'].each do |p|
        header = insert_published_by(p['header'])
        footer = p['footer']
        document = generate(header, footer)
        p['wiki_contents'] = document
        Furikake::Reporters::Backlog.new(p).publish
      end
    end

    private

    def generate(header, footer)
      documents = <<"EOS"
#{header}
#{@resource}
#{footer}
EOS
      documents
    end

    def insert_published_by(header)
      headers = header.split("\n")
      headers.insert(1, published_by)
      headers.insert(2, "\n")
      headers.join("\n")
    end
 
    def published_by
      "*Published #{Time.now} by [furikake](https://github.com/inokappa/furikake)*"
    end
  end
end

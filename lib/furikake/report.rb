require 'furikake/reporters/backlog'

module Furikake
  class Report
    include Furikake::Config

    def initialize
      @resource = Furikake::Resource.generate
      @params = read_furikake_yaml
    end

    def show
      @params['backlog']['projects'].each do |p|
        header = p['header']
        footer = p['footer']
        puts generate(header, footer)
      end
    end

    def publish
      @params['backlog']['projects'].each do |p|
        header = p['header']
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
#{published_by}
#{@resource}
#{footer}
EOS
      documents
    end

    def published_by
      "Published #{Time.now} by furikake (https://github.com/inokappa/furikake)"
    end
  end
end

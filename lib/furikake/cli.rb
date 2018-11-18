require 'furikake'

module Furikake
  class CLI < Thor
    desc 'version', 'version print.'
    def version
      puts Furikake::VERSION
    end

    desc 'show', 'resouces print.'
    def show
      report = Furikake::Report.new
      report.show
    end

    desc 'publish', 'resouces publish to something.'
    def publish
      report = Furikake::Report.new
      report.publish
    end

    desc 'setup', 'generate .furikake.yml template.'
    def setup
      Furikake::Setup.run
    end
  end
end

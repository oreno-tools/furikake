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
  end
end

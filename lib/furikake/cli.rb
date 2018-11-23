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

    desc 'publish', 'resouces publish to something. (Default: Backlog)'
    def publish
      report = Furikake::Report.new
      report.publish
    end

    desc 'monitor', 'resouces publish to something by daemonize process.'
    option :interval, type: :numeric, aliases: '-i', default: 3600, desc: 'specify monitor interval (sec).'
    option :pid, type: :string, aliases: '-p', default: 'furikake.pid', desc: 'specify PID file path (Default: furikake.pid)'
    def monitor
      monitor = Furikake::Monitor.new(options)
      monitor.run
    end

    desc 'setup', 'generate .furikake.yml template.'
    def setup
      Furikake::Setup.run
    end
  end
end

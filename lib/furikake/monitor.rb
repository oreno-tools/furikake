# Reference: https://www.mk-mode.com/octopress/2013/10/06/ruby-daemonize-script/

module Furikake
  class Monitor < Report
    def initialize(options)
      @logger = Logger.new(STDOUT)
      @flag_int = false
      @detach = options[:detach]
      @pid_file = options[:pid]
      @interval = options[:interval]
    end

    def run
      begin
        @logger.info 'furikake monitor を起動します.'
        daemonize
        set_trap
        monitor
        @logger.warn "furikake monitor を停止しました."
        File.delete(@pid_file) if File.file?(@pid_file)
      rescue => e
        @logger.error "monitor の起動に失敗しました. #{e}"
        exit 1
      end
    end

    private

    def daemonize
      begin
        Process.daemon(true, true) if @detach
        open(@pid_file, 'w') { |f| f << Process.pid }
      rescue => e
        @logger.error "monitor のデーモン化に失敗しました. #{e}"
        exit 1
      end
    end

    def set_trap
      begin
        Signal.trap(:INT)  { @flag_int = true } 
        Signal.trap(:TERM) { @flag_int = true }
      rescue => e
        @logger.error "monitor のトラップ設定に失敗しました. #{e}"
        exit 1
      end
    end

    def monitor
      i = 0
      while true
        if @interval == i
          publish
          i = 0
        end
        i += 1
        break if @flag_int
        sleep 1
      end
    end
  end
end

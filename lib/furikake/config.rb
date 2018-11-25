module Furikake
  module Config
    def read_furikake_yaml
      $stdout.sync = true
      begin
        YAML.load_file('.furikake.yml')
      rescue Errno::ENOENT
        Logger.new($stdout).error('.furikake.yml が存在していません.')
        exit 1
      rescue => ex
        Logger.new($stdout).error('.furikake.yml の読み込みに失敗しました. ' + ex.message)
        exit 1
      end
    end
  end
end
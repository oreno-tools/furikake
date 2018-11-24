module Furikake
  module Config
    def read_furikake_yaml
      begin
        YAML.load_file('.furikake.yml')
      rescue Errno::ENOENT
        Logger.new(STDOUT).error('.furikake.yml が存在していません.')
        exit 1
      rescue => ex
        Logger.new(STDOUT).error('.furikake.yml の読み込みに失敗しました. ' + ex.message)
        exit 1
      end
    end
  end
end
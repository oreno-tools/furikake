module Furikake
  module Config
    def read_furikake_yaml
      # open('.furikake.yml', 'r') { |f| YAML.load(f) }
      begin
        YAML.load_file('.furikake.yml')
      rescue Errno::ENOENT
        puts '.furikake.yml が存在していません.'
        exit 1
      rescue => ex
        puts '.furikake.yml の読み込みに失敗しました. ' + ex.message
        exit 1
      end
    end
  end
end
module Furikake
  module Config
    def read_furikake_yaml
      open('.furikake.yml', 'r') { |f| YAML.load(f) }
    end
  end
end
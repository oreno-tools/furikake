module Furikake
  class Resource
    def self.generate
      documents = ''
      load_resource_type.each do |type|
        if type.include?('addon')
          $LOAD_PATH.push(Dir.pwd + '/addons')
          require "#{type}"
          type_name = type.split('-')[-1]
          eval "documents.concat(Furikake::Resources::Addons::#{type_name.camelize}.report)"
          logger.info("リソースタイプ: #{type_name} の情報を取得しました.")
          documents.concat("\n\n")
        else
          begin
            require "furikake/resources/#{type}"
            eval "documents.concat(Furikake::Resources::#{type.camelize}.report)"
            logger.info("リソースタイプ: #{type} の情報を取得しました.")
            documents.concat("\n\n")
          rescue LoadError
            logger.warn("リソースタイプ: #{type} を読み込めませんでした.")
          rescue
            logger.warn("リソースタイプ: #{type} の情報を取得出来ませんでした.")
          end
        end
      end
      documents
    end

    def self.load_resource_type
      type = []
      config_defined_resources = load_config_resource_type
      default_resources = load_default_resource_type
      if default_resources == config_defined_resources
        type.push(default_resources)
      else
        type.push(config_defined_resources)
      end
      type.push(load_addons_resource_type)
      type.flatten
    end

    def self.load_default_resource_type
      default_resource_type = []
      Dir.glob(File.dirname(__FILE__) + '/resources/*').each do |r|
        default_resource_type << File.basename(r, '.rb') unless r.include?('stub')
      end
      default_resource_type.sort
    end

    def self.load_addons_resource_type
      addons_resource_type = []
      Dir.glob(Dir.pwd + '/addons/furikake-resource-addon-*').each do |r|
        addons_resource_type << File.basename(r, '.rb')
      end
      addons_resource_type.sort
    end

    def self.load_config_resource_type(path = nil)
      path = '.furikake.yml' if path.nil?
      begin
        config = YAML.load_file(path)
        config['resources']['aws'].sort
      rescue Errno::ENOENT
        logger.error('.furikake.yml が存在していません.')
        exit 1
      rescue => ex
        logger.error('.furikake.yml の読み込みに失敗しました. ' + ex.message)
        exit 1
      end
    end

    def self.logger
      Logger.new(STDOUT)
    end
  end
end

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
          documents.concat("\n\n")
        else
          require "furikake/resources/#{type}"
          eval "documents.concat(Furikake::Resources::#{type.camelize}.report)"
          documents.concat("\n\n")
        end
      end
      documents
    end

    def self.load_resource_type
      type = []
      Dir.glob(File.dirname(__FILE__) + '/resources/*').each do |r|
        type << File.basename(r, '.rb') unless r.include?('stub')
      end

      Dir.glob(Dir.pwd + '/addons/furikake-resource-addon-*').each do |r|
        type << File.basename(r, '.rb')
      end
      type
    end
  end
end

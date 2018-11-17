module Furikake
  class Resource
    def self.generate
      documents = ""
      load_type.each do |type|
        require "furikake/resources/#{type}"
        eval "documents.concat(Furikake::Resources::#{type.camelize}.report)"
        documents.concat("\n")
      end
      documents
    end

    def self.load_type
      type = []
      Dir.glob(File.dirname(__FILE__) + '/resources/*').each do |r|
        type << File.basename(r, '.rb')
      end
      type
    end
  end
end

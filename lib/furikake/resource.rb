module Furikake
  class Resource
    def initialize
    end
    
    def generate
      types = %w(
        ec2 alb clb lambda elasticsearch_service
        kinesis rds directory_service vpc
      )

      documents = ""
      types.each do |type|
        require "furikake/resources/#{type}"
        eval "documents.concat(Furikake::Resources::#{type.camelize}.report)"
        documents.concat("\n")
      end
      documents
    end
  end
end
require 'furikake/formatters/markdown'

module Furikake
  class Formatter
    def self.shaping(format, contents)
      Furikake::Formatters::Markdown.write(contents) if format.nil?
    end
  end
end

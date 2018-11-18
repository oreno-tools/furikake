require 'erb'
require 'markdown-tables'

module Furikake
  module Formatters
    class Markdown
      def self.write(c)
        contents = <<EOS
### <%= c[:title] %>

<%- c[:resources].each do |r| -%>
<%- if r[:subtitle] != '' -%>
#### <%= r[:subtitle] %>

<%- end -%>
<%- if ! r[:resource].empty? -%>
<%= MarkdownTables.make_table(r[:header], r[:resource], is_rows: true, align: 'l') %>
<%- else -%>
<%= 'N/A' %>
<%- end -%>
<%- end -%>

EOS
        erb = ERB.new(contents, nil, '-')
        erb.result(binding).chomp
      end
    end
  end
end

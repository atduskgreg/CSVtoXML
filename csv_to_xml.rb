require 'rubygems'
require 'faster_csv'

class CSVtoXML
  def self.convert( path, opts={} )
    row_name = opts[:row_name]
    top_node = opts[:top_node]
    
    result = ""
    if top_node
      result << "<#{CSVtoXML.tagify(top_node)}>"
    end
    
    FasterCSV.foreach(path, {
      :converters => lambda do |field, field_info|
         "<#{CSVtoXML.tagify(field_info.header)}>#{CSVtoXML.escape_node_contents(field)}</#{CSVtoXML.tagify(field_info.header)}>"
      end, :headers => :true} 
    ) do |row| 
      
      result << "<#{CSVtoXML.tagify(row_name)}>" << row.fields.join("") << "</#{CSVtoXML.tagify(row_name)}>"
    end
    
    if top_node
      result << "</#{CSVtoXML.tagify(top_node)}>"
    end
    result
  end
  
  def self.tagify(tag)
    tag.gsub(" ", "_")
  end
  
  def self.escape_node_contents(text)
    text.gsub("<", "&lt;").gsub(">", "&gt;") if text
  end
end
require 'rubygems'
require 'redcloth'
require 'doc/xml'
require 'rexml/document'


module Rbml
  module Language
    module Doc
      module Rss
        include Xml

        def tags; %w(title link description language pubDate lastBuildDate docs generator managingEditor webMaster item guid) end
        def start_tag(*options)
          "<?xml version='1.0'?><rss version='2.0'><channel>"
        end
        def end_tag
          "</channel></rss>"
        end
        def format(doc)
          fdoc = REXML::Document.new doc.assemble_doc
          fdoc.write doc.formatted_doc, 1
          doc.formatted_doc
        end
        def method_missing(method, *args, &blk)
          if tags.include? method.to_s
            print_tag(method.to_s, args, &blk)
          end  
        end
      end
    end
  end
end

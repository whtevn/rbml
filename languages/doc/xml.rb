require 'doc/base'

module Rbml
  module Language
    module Doc
      module Xml
        include Base
        def tags;[]end
        def inline what; what end
    
        alias :i :inline 
  
        def method_missing(method, *args, &blk)
          print_tag(method.to_s, args, &blk)  
        end
  
        def print_tag(tag, *args, &blk)
          options = {}
          content = ''
          args.flatten.each do |a| 
            content = a if a.kind_of? String
            options.merge! a if a.kind_of? Hash
          end
    
          attributes = ' '
          options.each{|k, v| attributes << "#{k}='#{v}' "} if options.kind_of? Hash
      
          if block_given?
            ["<#{tag}#{attributes unless attributes.blank?}>", blk, "</#{tag}>"]
          elsif !content.blank?
            "<#{tag}#{attributes unless attributes.blank?}>#{content}</#{tag}>"
          else
            "<#{tag}#{attributes unless attributes.blank?} />"
          end
        end

        def cdata string=nil, &blk
          string||=''
          if block_given?
            ["<![CDATA[#{string}", blk, "]]>"]
          else
            "<![CDATA[#{string}]]>"
          end
        end
      end
    end
  end
end

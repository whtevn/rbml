require 'rubygems'
require 'redcloth'
require 'doc/xml'
require 'rexml/document'


module Inclusion
  def include(file)
    run_file [$template_dir, file.as_partial].join('/')+'.rbml'
  end
end

module Rbml
  module Language
    module Doc
      module Xhtml
        include Xml
        ::Kernel.send(:undef_method, :p)
          
        def tags; %w(body title head p hr script div ul li html a br span h1 h2 h3 h4 h5 h6 strong img i u b pre kbd code cite strong em ins sup sub del table tr td th ol blockquote)end
    
        def stylesheets dir, *sheets
          all_sheets = ''
          sheets.each {|sheet| all_sheets << stylesheet(dir, sheet)}
          all_sheets
        end
      
        def stylesheet dir, what
          "<link rel='stylesheet' href='#{dir}#{what}.css' type='text/css' />"
        end
    
        def doctype(options)
          strictness = options[:strict] ? "Strict" : "Transitional"
          "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 #{strictness}//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-#{strictness.downcase}.dtd\">"
        end
    
        def charset(encoding)
          "<meta http-equiv='Content-Type' content='text/html; charset=#{encoding}' />"
        end
    
        def start_tag(*options)
          "#{doctype options.first}<html>"
        end
    
        def end_tag *options
          "</html>"
        end
        
        def format(doc)
          fdoc = REXML::Document.new doc.assemble_doc
          fdoc.write doc.formatted_doc, 1
          doc.formatted_doc
        end
    
        def textilize(str)      
          RedCloth.new(str).to_html
        end
        alias :t :textilize
      
        def method_missing(method, *args, &blk)
          if tags.include? method.to_s
            print_tag(method.to_s, args, &blk)
          end  
        end
      end
    end
  end
end

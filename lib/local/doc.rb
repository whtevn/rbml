require "base"

module Rbml
  class Doc < Base
    attr_accessor :assemble_doc
    attr_accessor :formatted_doc
    
    def self.render(language, options, &block)
      options[:format] = true if options[:format].nil? 
      d = Doc.new(language)
      d.assemble_doc = ""
      display = lambda do |result|
        if result.kind_of? Array
          result.each {|r| r.kind_of?(Proc) ? d.instance_eval_each(r, &display) : d.assemble_doc<<(r) }
        else
          d.assemble_doc << result
        end
      end
      d.assemble_doc << d.dsl.start_tag(options) unless options[:partial] 
      d.instance_eval_each(block, &display)
      d.assemble_doc << d.dsl.end_tag unless options[:partial] 
      d.formatted_doc = ''
      begin
        if options[:format]
          d.format 
        else
          d.formatted_doc = d.assemble_doc
        end
      ensure
        d.print
      end
    end
    
    def format
      dsl.format(self)
    end
    
    def print
      formatted_doc.blank? ? assemble_doc : formatted_doc
    end
  end
end

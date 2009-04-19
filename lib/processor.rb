module Rbml
  class Processor
    
		attr_accessor :filename

    ROUTES = begin
			YAML::load_file(ENV['routes'])
		rescue
			{:xhtml => "Doc", 
      :rss => "Doc", 
      :shell => "Shell",
			:script => "Script"}
		end

		def initialize(file=nil)
			@filename = file if file
		end

    def route_for(name)
      ROUTES.fetch(name)
    end

    def method_name; caller[0][/`([^']*)'/, 1]; end

    def spawn(options={}, *args, &block)
      language = if args.first.kind_of?(Hash) and args.first[:as_language]
         args[:as_language]
      else
         method_name 
      end
      language = load_language(language)
      render(method_name, language, options, &block)
    end

    def render(method_name, language, options, &block)
			options[:file_to_process] = filename
      Rbml.const_get(route_for(method_name.to_sym)).render(language, options, &block)
    end
    
    def load_language(language)
      require "#{route_for(language.to_sym).downcase}/#{language}"
      "Language::#{route_for(language.to_sym)}::#{language.camelize}".to_m
    end
    
    def self.read(file)
      File.read(file)
    end
    
    def self.run(argv)
			ext = argv.sub(/\.erb$/, '').sub(/^.*\./, '').to_sym
			ROUTES[ext] ? new(argv).send(ext) : new(argv).instance_eval(File.read(argv))
    end 
    
    ROUTES.each_key do |k|
      alias_method k, :spawn
    end
  end
end

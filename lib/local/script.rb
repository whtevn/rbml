require 'erb'
module Rbml
  DECAYING_RBML_USER_SCRIPT = []
  PRELOADED_RESPONSE = []
	class Shell < Base
		alias :_read_user_input_ :read_user_input
		def read_user_input(prompt)
			line = ""
      until(PRELOADED_RESPONSE.empty?) do
       PRELOADED_RESPONSE.shift
      end
			until(!line.empty? or not DECAYING_RBML_USER_SCRIPT or DECAYING_RBML_USER_SCRIPT.empty?) do
				line = DECAYING_RBML_USER_SCRIPT.shift
        if line.kind_of? Hash
          PRELOADED_RESPONSE << line.values.first
          PRELOADED_RESPONSE.flatten!
          line = line.keys.first
        end
			end
			if line.nil? or line.empty?
				_read_user_input_ prompt
			else
        Readline::HISTORY.push(line)
        puts("#{prompt} #{line}")
				line
			end
		end
	end

  IO.class_eval do
    alias :_gets_ :gets
    def gets
      response = PRELOADED_RESPONSE.shift
       
      if response and not response =~ /\?$/ # /\?/ ?
      
        $stdout.puts response
        return response+$/
      elsif response =~ /\?$/
        response.sub!(/\?$/, '').strip!
        Readline.completion_proc = lambda {|tab| response }
        line = Readline::readline("\n[tab for '#{response}'] > ")
        return line+$/
      end rescue _gets_
      _gets_
    end
  end

  class Script < Base
    def self.render(language, options, &block)
      script = get_file(options[:file_to_process])
			processor = script.shift.sub(/^#:/, '').sub("~", ENV['HOME']).sub("[RBML_HOME]",ENV['RBML'])
      append_to_script(scrub_comments(script))
      ::Rbml::Processor.run processor
		end

    def self.scrub_comments script
      script.collect{|s| s.sub!(/#.*/, ''); s.strip }.select {|s| !s.empty?}
    end

    def self.get_file file
      if(file.sub(/^.*\./, '') == 'erb')
				 ERB.new(File.read(file)).result(binding)
			else
				 File.read(file)
			end.split($/).collect {|s| s.strip }.select{|s| !s.empty?}
    end

    def self.append_to_script script
      script.each {|line|
        if line =~ /^-/
          line = line.sub(/^-/, '').strip
          tmp = DECAYING_RBML_USER_SCRIPT.pop  
          case tmp
          when Hash
            tmp.values.first << line
          else
            line = {tmp => [line]}
          end
        end
        break if line == "__END__"
        DECAYING_RBML_USER_SCRIPT << line unless line.empty?
      }
    end
	end
end

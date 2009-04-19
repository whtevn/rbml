require 'readline'
module Rbml
  class Shell < Base
		def read_user_input prompt
      line = Readline::readline(prompt)
      Readline::HISTORY.push(line)
      line
		end

    def self.render(language, options, &block)
      d = Shell.new(language)
      display = lambda { |result| result }
      loop do
        begin
          d.instance_eval_each(block, &display) 
          args = d.read_user_input(options[:prompt]).split
          d.dsl.__send__("call", *args) unless args.empty?
        rescue Interrupt
          puts "\nExiting #{options[:name]}..."
          break
        end
      end
    end
  end
end

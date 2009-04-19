
require 'cli_tools'

module Rbml
  module Language
    module Shell
      module Shell
        include CliTools
        include Flagger

        DEFINITION = {"unknown_command" => lambda {|name| puts "unknown command type 'help' for instructions"}}
        
        def set(method, &proc)
          DEFINITION.update({method.to_s => proc})
          nil
        end
        
        def bad_method(e)
          puts "\n-- Internal Error--\n" 
          puts e.display
          puts "\n"
          puts e.backtrace
        end

        def call(method, *args)
          clear_arguments
          begin
            args.empty? ? DEFINITION.fetch(method)[nil] : DEFINITION.fetch(method)[args]
          rescue IndexError => e
            if e.backtrace.first.match(/base.rb/)
              bad_method(e)
            else
              DEFINITION.fetch("unknown_command")[method, args]
            end
          rescue => e
            bad_method(e)
          ensure
            puts "\n"
          end
        end
      end
    end
  end
end

module Rbml
  class Daemon < Base
    def self.render(language, options, &block)
      d = Daemon.new(language)
      display = lambda do |result|
          puts "#{result}\n" unless result.nil?
        end
      loop do
        d.instance_eval_each(block, &display)
        stdin = IO.new(0, "w+")
        d.dsl.__send__("call", stdin.gets.chomp)
      end
  end
end
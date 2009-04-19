module Rbml
  class Base
    include Primitives
    attr_accessor :dsl
    
    def initialize(language=nil)
      @dsl = BlankSlate.new(language)
    end
      
    def instance_eval_each(code, &blk)
      @breaker = BlockBreaker.new do |name, args, block|
        yield @dsl.__send__(name, *args, &block)
      end
      @breaker.__instance_eval__ &code
    end
  end
end

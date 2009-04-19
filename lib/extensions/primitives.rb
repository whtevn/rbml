module Inclusion
  def run_block &blk
    __instance_eval__ &blk
  end

  def run_file(file)
    __instance_eval__ ::Rbml::Processor.read(file)
  end
  
  def include(file)
    run_file file+'.rbml'
  end
end

module Primitives
  class BlankSlate #:nodoc:
    alias :__instance_eval__ :instance_eval
    alias :__extend__ :extend
    alias :__respond_to? :respond_to?
    alias :__send__ :send
    alias :__instance_variable_get :instance_variable_get
    alias :__instance_variable_set :instance_variable_set
  
    instance_methods.each {|m| undef_method m unless m =~ /^__/ }
  
    def initialize(mod = nil)
      __extend__ mod if mod
    end
  end
  
  class BlockBreaker < BlankSlate #:nodoc:
    include Inclusion

    def initialize(&block)
      if block_given?
        @handler = block
      else
        raise NoBlockGiven, "Must be a block to break!"
      end
    end
    def method_missing(name, *args, &block)
      @handler.call(name, args, block) 
    end
  end

  class NoBlockGiven < StandardError #:nodoc:
  end
end

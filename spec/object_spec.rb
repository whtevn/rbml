require File.dirname(__FILE__) + '/spec_helper'

def sample_body
  body do
    p 'whatup'
  end
end

context "my extended object" do
  setup do
    @doc = ::Rbml::Doc.new
    #@breaker = mock('blockbreaker')
    @myproc = Proc.new do
      title "line 1"
      div "line 2"
    end
  end
  
  specify 'instance_eval_each should be callable' do
    lambda{ @doc.instance_eval_each(@myproc) {lambda{sample_body}} }.should_not_raise
  end
  
  specify "instance_eval_each should work" do
    arr = []
    @doc.instance_eval_each(@myproc) {|result| arr << result }
    arr.length.should_be 2
  end
end

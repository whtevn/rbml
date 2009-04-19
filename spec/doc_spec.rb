require File.dirname(__FILE__) + '/spec_helper'

class XhtmlSpecr
  include ::Rbml::Xhtml
end

context "a new Doc instance" do
  setup do
    @doc = XhtmlSpecr.new
  end
  
  specify "should render doctype" do
    @doc.doctype({:type=>:xhtml, :version=>"1.0", :strict=>false}).should == "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">" 
  end
  
  specify 'should render head' do
    @doc.instance_eval_each(head{ }).should_have_tag '//head'
  end
  
  specify 'should render body' do
    @doc.body{}.should_have_tag  '//body'
  end
  
  specify 'should be able to set attributes on body' do
    @doc.body(:attributes =>{:id => 'test'}){}.should_have_tag  "//body[@id='test']"
  end
end

context 'when rendering the head' do
  setup do
    @doc = ::Rbml::Doc.new
  end
  
  specify 'should be able to set a title' do
    @doc.head{title "test"}.should_have_tag '//title'
    @doc.head{title "test"}.tag('//title').should_contain "test"
  end
  
  specify 'should be able to set stylesheets' do
    @doc.head{stylesheets :base}.should_have_tag  "//link[@href='/stylesheets/base.css']"
  end
  
  specify 'should be able to set multiple stylesheets' do
    @doc.head{stylesheets :base, :test}.should_have_tag  ["//link[@href='/stylesheets/base.css']", "//link[@href='/stylesheets/base.css']"]
  end
  
  specify 'should be able to handle inline strings' do
   @doc.head{"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>"}.should == "test"
  end
end

context "loading template into render" do
  setup do
    @doc = mock('doc')
    ::Rbml::Doc.should_receive(:new).and_return(@doc)
  end
  
  specify "should pass to instance_eval_each" do
    @doc.should_receive(:instance_eval_each)
    load File.dirname(__FILE__) + '/fixtures/test.rbml'
  end
end
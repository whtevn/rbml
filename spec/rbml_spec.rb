require File.dirname(__FILE__) + '/spec_helper'

context 'when rendering the document' do
  setup do
   ::Rbml::Processor.run(File.dirname(__FILE__) + '/fixtures/test.rbml')
  end
end
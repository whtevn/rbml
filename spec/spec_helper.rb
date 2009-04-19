require 'rubygems'
require_gem 'rspec'
require 'spec'
require 'hpricot'
$: << File.dirname(__FILE__) + "/../lib"
require 'rbml'

class Hpricot::Elem
  def should_contain(value)
    self.inner_text.include?(value)
  end
  
  # courtesy of 'thomas' from the comments
  # of _whys blog - get in touch if you want a better credit!
  def inner_text
    self.children.collect do |child|
      child.is_a?(Hpricot::Text) ? child.content : child.inner_text
    end.join.strip
  end
end

class String
  def should_have_tag(*search_string)
    search_string.each { |string| Hpricot(self).search(string).should_not_be_empty }
  end
  
  def tag(search_string)
    Hpricot(self).at(search_string)
  end
end
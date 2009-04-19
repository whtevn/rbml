# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'lib/rbml.rb'

RDOC_OPTS = ['--quiet', '--title', "Rbml documentation",
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README",
    "--inline-source"]
    
Hoe.new('rbml', Rbml::VERSION) do |p|
  p.rubyforge_name = 'rbml'
	p.email = "evan.short@gmail.com"
	p.author = "jake howerton, evan short"
  p.summary = 'Rbml is a dsl framework for writing other languages in ruby'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.rdoc_pattern =  /^(lib|bin|languages)|txt$/
  p.spec_extras = {:rdoc_options => '--inline-source'}
end


# vim: syntax=Ruby

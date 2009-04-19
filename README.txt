rbml
    by Jake Howerton, Evan Short
    http://rbml.rubyforge.org

== DESCRIPTION:
  
rbml is a block processing engine that serves as a framework for writing
nested DSLs. Currently rbml has been implemented in document processing
(+xml+, +xhtml+) and command line interfacing. daemons and some level of
scripting capability are anticipated in 0.0.7

== FEATURES/PROBLEMS:

* can load rbml partials using +include+ method
* sample support for command line interfaces
* document processing: xml, xhtml
* XML support is totally untested (we don't need it right now...)

== SYNOPSIS:

<tt>rbml path/to/file.rbml</tt>

file.rbml:

	xhtml :doctype => {:type=>:xhtml, :version=>"1.0", :strict=>false} do
	  head do
	    title "Sample Site"
	    stylesheets :base, :links
	    #COMMENTS DONT GET EVAL'd
	  end

	  body do
	    textilize "*Header*"
	    div "this is our first html doc!"
	    p "its really awesome"
	    myvar = "withconcat"
	    p do
	      inline "dot operator #{myvar}"
	      span "nested span"
	    end
	  end
	end

Outputs

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html>
	   <head>
	     <title>Sample Site</title>
	     <link href='/stylesheets/base.css' rel='stylesheet' type='text/css'/>
	     <link href='/stylesheets/links.css' rel='stylesheet' type='text/css'/>
	   </head>
	   <body>
	     <p>
	       <strong>Header</strong>
	     </p>
	     <div>this is our first html doc!</div>
	     <p>its really awesome</p>
	     <p>dot operator withconcat<span>nested span</span>
	     </p>
	   </body>
	</html>
	
== REQUIREMENTS:

* RedCloth
* REXML

== INSTALL:

gem install rbml

== LICENSE:

(The MIT License)

Copyright (c) 2007 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

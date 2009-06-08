~ Textpow ~
~~ A Library for Processing TextMate Bundles ~~

#Introduction# | index

= What is Textpow? =
Textpow is a library to parse and process 
[Textmate http://macromates.com] bundles. Although created created for their
use in a word processor, these bundles have many other uses. For example, we
have used them to create a syntax highligting 
[utility http://ultraviolet.rubyforge.org] and also the markup rendering 
[engine http://mama.rubyforge.org] used to render this
documentation.

= Requirements =

* [Oniguruma http://www.geocities.jp/kosako3/oniguruma/] regular expression library (/>= 4.x.x/)
* [Oniguruma for Ruby http://www.geocities.jp/kosako3/oniguruma/] ruby bindings for oniguruma (/>= 1.1.x/)

= Installation =

If you have [rubygems http://docs.rubygems.org/] installation is straightforward by typing 
(as root if needed):

--------hl shell-unix-generic,,false------
gem install -r textpow --include-dependencies
------------------------------------------

If you prefer to get the sources, the last stable version may be
downloaded [here http://rubyforge.org/frs/?group_id=3513].

= Status =

The current version of Textpow (0.9.0) is able to parse syntax (/tmLanguage/, /tmSyntax/)
and theme (/tmTheme/) files.

#Use#

= Syntax files and text parsing =

The idea of parsing is to process some /input text/ using the rules defined in 
a /syntax [file > syntax_files]/ (which are discussed in detail in Textmate 
[documentation http://macromates.com/textmate/manual/language_grammars#language_grammars]).
The text is parsed line by line, and, events are sent to a /[processor > processors]/
according to how the text matches the syntax file.

-------dot parsing_overview, Overview of the parsing process.----------
digraph G {
   node [fontname=Helvetica, fontsize=10];
   edge [fontname=Helvetica, style=dashed, fontsize=10, decorate=true, fontcolor="#0066aa"];
   center=true; 
   {
      rank=same;
      node [shape=invhouse, style="filled", color="#333399", fillcolor="#6666cc", fontcolor="white"];
      syntax_file[label="Syntax file"];
      text[label="Input text"];
   }
   {     
      node [shape=box, style="filled", color="#993333", fillcolor="#cc6666", fontcolor="white"]
      syntax_object[label="SyntaxNode"];
      processor[label="Processor", shape=box];
   }
   parse [label="", style=invis, fontsize=0,height=0,width=0,shape=none];
   rank=same{syntax_object; parse};
   
   syntax_file -> syntax_object [label="  SyntaxNode#load"];
   syntax_object -> parse [arrowhead=none];
   text -> parse [arrowhead=none];
   parse -> processor [label="  SyntaxNode#parse"];

}
-----------------------------------------------------------------------

= For the impatient =

Parsing a file using Textpow is as easy as 1-2-3!

1.  Load the Syntax File:

    ---hl ruby,,false---
    require 'textpow'
    syntax = Textpow::SyntaxNode.load("ruby.tmSyntax")
    -------------

2. Initialize a processor:
    ---hl ruby,,false---
    processor = Textpow::DebugProcessor.new
    -------------

3. Parse some text:
    ---hl ruby,,false---
    syntax.parse( text,  processor )
    -------------

= The gory details =


== Syntax files == | syntax_files
At the heart of syntax parsing are ..., well, syntax files. Lets see for instance
the example syntax that appears in textmate's 
[documentation http://macromates.com/textmate/manual/language_grammars#language_grammars]:


---------hl property_list---------
 {  scopeName = 'source.untitled';
    fileTypes = ( txt );
    foldingStartMarker = '\{\s*$';
    foldingStopMarker = '^\s*\}';
    patterns = (
       {  name = 'keyword.control.untitled';
          match = '\b(if|while|for|return)\b';
       },
       {  name = 'string.quoted.double.untitled';
          begin = '"';
          end = '"';
          patterns = ( 
             {  name = 'constant.character.escape.untitled';
                match = '\\.';
             }
          );
       },
    );
 }
----------------------------------

But Textpow is not able to parse text pfiles. However, in practice this is not a problem,
since it is possible to convert both text and binary pfiles to an XML format. Indeed, all 
the syntaxes in the Textmate syntax [repository http://macromates.com/svn/Bundles/trunk/Bundles/]
are in XML format:

---------hl xml---------
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>scopeName</key>
   <string>source.untitled</string>
   <key>fileTypes</key>
   <array>
      <string>txt</string>
   </array>
   <key>foldingStartMarker</key>
   <string>\{\s*$</string>
   <key>foldingStopMarker</key>
   <string>^\s*\}</string>
   <key>patterns</key>
   <array>
      <dict>
         <key>name</key>
         <string>keyword.control.untitled</string>
         <key>match</key>
         <string>\b(if|while|for|return)\b</string>
      </dict>
      <dict>
         <key>name</key>
         <string>string.quoted.double.untitled</string>
         <key>begin</key>
         <string>"</string>
         <key>end</key>
         <string>"</string>
         <key>patterns</key>
         <array>
            <dict>
               <key>name</key>
               <string>constant.character.escape.untitled</string>
               <key>match</key>
               <string>\\.</string>
            </dict>
         </array>
      </dict>
   </array>
</dict>
------------------------

Of course, most people find XML both ugly and cumbersome. Fortunately, it is 
also possible to store syntax files in YAML format, which is much easier to 
read:

-------------hl yaml---------------
--- 
fileTypes: 
- txt
scopeName: source.untitled
foldingStartMarker: \{\s*$
foldingStopMarker: ^\s*\}
patterns:
- name: keyword.control.untitled
  match: \b(if|while|for|return)\b
- name: string.quoted.double.untitled
  begin: '"'
  end: '"'
  patterns:
  - name: constant.character.escape.untitled
    match: \\.
-----------------------------------

== Processors == | processors

Until now we have talked about the parsing process without explaining what
it is exactly. Basically, parsing consists in reading text from a string or
file and applying tags to parts of the text according to what has been
specified in the [syntax file > syntax_files].

In textpow, the process takes place line by line, from the beginning to the
end and from left to right for every line. As the text is parsed, events are
sent to a /processor/ object when a tag is open or closed and so on. 
A processor is any object which implements one or more of the following
methods:

------------hl ruby--------------
class Processor
   def open_tag name, position
   end
      
   def close_tag name, position
   end
      
   def new_line line
   end
      
   def start_parsing name
   end
   
   def end_parsing name
   end
end
---------------------------------

* `open_tag`. Is called when a new tag is opened, it receives the tag's name and
    its position (relative to the current line).
* `close_tag`. The same that `open_tag`, but it is called when a tag is closed.
* `new_line`. Is called every time that a new line is processed, it receives the
    line's contents.
* `start_parsing`. Is called once at the beginning of the parsing process. It 
    receives the scope name for the syntax being used.
* `end_parsing`. Is called once after all the input text has been parsed. It 
    receives the scope name for the syntax being used.

Textpow ensures that the methods are called in parsing order, thus, 
for example, if there are two subsequent calls to `open_tag`, the first
having `name="text.string", position=10` and the second having 
`name="markup.string", position=10`, it should be understood that the
`"markup.string"` tag is /inside/ the `"text.string"` tag.

# Links #


= Rubyforge project page =

* [Textpow http://rubyforge.org/projects/textpow].

= Documentation =

* [Textmate documentation http://macromates.com/textmate/manual/].
* [YAML cookbook http://yaml4r.sourceforge.net/cookbook/].

= Requirements =

* [Oniguruma http://www.geocities.jp/kosako3/oniguruma/].
* [Oniguruma for ruby http://rubyforge.org/projects/oniguruma/].
* [Ruby plist parsing library http://rubyforge.org/projects/plist].

= Projects using Textpow =

* [Ultraviolet Syntax Highlighting Engine http://ultraviolet.rubyforge.org/].
* [Macaronic markup engine http://mama.rubyforge.org/].

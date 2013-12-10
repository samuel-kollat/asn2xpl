# ASN2XPL Compiler
# Module: ASNModule
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class ASNModule
	attr_reader :name, :parent

	@@syntax = [:custom, :keyword, :assingment, :keyword, :keyword]
  @@iteration_state = 4

	def initialize()
		@name = ""
		@state = 0
		@children = []
    @parent = self
	end

	def add_name( name )
		@name = name
	end

  def add_child( child )
    @children << child
  end

  def closed?()
    @state >= @@syntax.size
  end

	def add( token )
    # Possible iteration of child objects
    if(@state == @@iteration_state && token.value != "END")
      return nil
    end
    
    # Syntax analysis
		if(token.type == @@syntax[@state])
			syntax_error = case @state
			when 0
				@name = token.value
				false
			when 1
				token.value != "DEFINITIONS"
      when 2
        false
			when 3
				token.value != "BEGIN"
			when 4
				token.value != "END"
			else
				true
			end
			@state += 1
		else
			syntax_error = true
		end

		if(syntax_error)
			raise ASNSyntaxError, token.value
		end
		
    return self
	end

	def to_xpl( indent )
    indentation = create_indent(indent)
    puts "#{indentation}<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
    puts "#{indentation}<!-- BER encoding --> "
		puts "#{indentation}<xpl:module name=\"#{@name}\" xmlns:xpl=\"http://netfox.fit.vutbr.cz/2013/xplschema\">"
    @children.each do |child|
      child.to_xpl(indent+1)
    end
    puts "#{indentation}</xpl:module>"
	end

end

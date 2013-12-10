# ASN2XPL Compiler
# Module: ASNSequence
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

require_relative 'asn_pair'

class ASNSequence
	attr_reader :name, :parent

  @@syntax = [:custom, :assingment, :keyword, :leftcur, :rightcur]

	def initialize( name, parent )
		@name = name
		@children = []
		@parent = parent
    @state = 3  # start at left curly bracket
	end

  def closed?()
    @state >= @@syntax.size
  end

  def add( token )
    successor = self

    if(token.type == @@syntax[@state])
			syntax_error = case @state
			when 0
				@name = token.value
				false
			when 1
        false
      when 2
				token.value != "SEQUENCE"
			when 3
        #successor = nil
        false
			when 4 
				false
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

    return successor
  end

	def to_xpl( indent )
    indentation = create_indent(indent)

    puts "#{indentation}<xpl:type name=\"#{@name}\">"
    puts "#{indentation}  <xpl:record>" 
    @children.each do |child|
      child.to_xpl(indent+2)
    end
    puts "#{indentation}  </xpl:record>" 
    puts "#{indentation}</xpl:type>" 
	end
end

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
	attr_reader :name

	@@syntax = [:custom, :keyword, :assingment, :keyword, :keyword]

	def initialize()
		@name = ""
		@state = 0
		@children = []
	end

	def add_name( name )
		@name = name
	end

	def add( token )
		successor = self

		if(token.type == @@syntax[@state])
			syntax_error = case @state
			when 0
				@name = token.value
				false
			when 1
				token.value != "DEFINITIONS"
			when 3
				successor = nil
				token.value != "BEGIN"
			when 4
				token.value != "END"
			else
				false
			end
			@state += 1
		else
			syntax_error = true;
		end

		if(syntax_error == true)
			raise ASNSyntaxError, token.value
		end
		successor
	end

	def to_xpl()
		"<xpl:module name=\"#{@name}\" xmlns:xpl=\"http://netfox.fit.vutbr.cz/2013/xplschema\">"
	end

end
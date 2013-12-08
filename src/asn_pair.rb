# ASN2XPL Compiler
# Module: ASNPair
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class ASNPair
	attr_reader :name

	def initialize( name )
		@name = name
		@type = []
	end

	def add_type( type )
		@type << type
	end

	def to_xpl()
		"<xpl:module name=\"#{@name}\"/>"
	end

end
# ASN2XPL Compiler
# Module: ASNTypeObject
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2014
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class ASNTypeObject
	attr_accessor :type

	def initialize()
		@type = :undef
		@valid = false
	end

	def valid?()
		return @valid
	end

	def parse_type( scanner )
	end

end
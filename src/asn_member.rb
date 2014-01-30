# ASN2XPL Compiler
# Module: ASNMember
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2014
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

require_relative 'scanner'
require_relative 'common'
require_relative 'asn_typeobject'

class ASNMember < ASNTypeObject
	attr_reader :parent, :root

	def initialize( parent, root )
		super()
		@name = ""
		@parent = parent
		@root = root
		@empty = true
		@children = []
	end

	def run()
	end

	def empty?()
		return @empty
	end

end
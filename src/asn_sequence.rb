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
	attr_reader :name

	def initialize( name, parent )
		@name = name
		@items = []
		@parent = parent
	end

	def add_item( params={} )
		pair = ASNPair.new params
		@items << pair
	end

	def to_xpl()
		"<xpl:field name=\"#{@name}\"/>"
	end
end
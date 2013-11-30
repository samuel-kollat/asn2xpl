# ASN2XPL Compiler
# Module: Parser
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

require_relative 'scanner'

class Parser

	def initialize( file )
		@scanner = Scanner.new file
	end

	def run()
		@scanner.each_token() do |token|
			puts "#{token.value}\t-- #{token.type}"
		end
	end

end # Class Parser
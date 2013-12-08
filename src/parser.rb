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
require_relative 'common'

require_relative 'asn_module'
require_relative 'asn_sequence'

class Parser

	def initialize( file )
		@scanner = Scanner.new file
		@root = ASNModule.new
		@actual = @root
	end

	def run()
		Debug.header("Lexemes")
		unknow_name = ""	# Name of next possible object 
		last_know = @root	# Last know object

		@scanner.each_token() do |token|
			Debug.line("#{token.value}\t-- #{token.type}")
		 	begin
		 		if(@actual) # Object is known
		 			@actual = @actual.add(token)
		 		else # Create Metastabile object
		 			# !!!
		 			if(token.type == :custom)
		 				@unknow_name = token.value
		 			elsif (token.type == :keyword)
		 				@actual = case token.value
		 				when "SEQUENCE"
		 					ASNSequence.new unknow_name last_know
		 				else
		 					raise ASNSyntaxError, token.value
		 				end
		 				last_know.add_child(@actual)
		 			else
		 				raise ASNSyntaxError, token.value
		 			end
		 		end
		 	rescue ASNSyntaxError => error
		 		puts "Syntax error: #{error}"
		 		exit 1
		 	end
		end
	end

end # Class Parser
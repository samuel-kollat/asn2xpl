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
require_relative 'asn_metastabile'

class Parser

	def initialize( file )
		@scanner = Scanner.new file
		@root = ASNModule.new
		@actual = @root
	end

	def run()
		Debug.header("Lexemes")
		unknow_name = ""	# Name of next possible object 
		last_known = @root	# Last know object
    metastabile = nil

		@scanner.each_token() do |token|
			Debug.line("#{token.value}\t-- #{token.type}")
		 	begin
		 		if(@actual) # Object is known
          last_known = @actual
		 			@actual = @actual.add(token)
          if @actual.nil? # possible place of errors 
            metastabile = Metastabile.new
            @actual = metastabile.add(token, last_known) 
            if(@actual)
              last_known.add_child(@actual)
              metastabile = nil
            end
          end
		 		else
          @actual = metastabile.add(token, last_known)
          if(@actual)
            last_known.add_child(@actual)
            metastabile = nil
          end
		 		end
        @actual = @actual.parent if @actual and @actual.closed?
		 	rescue ASNSyntaxError => error
		 		puts "Syntax error: #{error}"
		 		exit 1
		 	end
		end

    if(@actual != @root || !@root.closed?)
      puts "Syntax error: Definitions after Module"
      exit 1
    end

    return @root
	end

end # Class Parser

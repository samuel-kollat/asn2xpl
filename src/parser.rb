# ASN2XPL Compiler
# Module: Parser
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
require_relative 'asn_module'

class Parser

    def initialize( file )
        @scanner = Scanner.new file
        @module = ASNModule.new
    end

    def run()
        begin
            @module.run @scanner
        rescue ASNSyntaxError => error
            puts "ASNSyntax error:#{@scanner.line_number}: #{error}"
            exit 1
        end
        return @module
    end

end # Class Parser

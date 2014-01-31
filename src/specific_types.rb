# ASN2XPL Compiler
# Module: Specific Type Modules
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2014
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

require_relative 'common'

module Sequence
    def Sequence.extended( mod )
        Debug.line("Extended: Sequence type")
    end
end

module Choice
    def Choice.extended( mod )
        Debug.line("Extended: Choice type")
    end
end

module OctetString
    def OctetString.extended( mod )
        Debug.line("Extended: Octet String type")
    end
end
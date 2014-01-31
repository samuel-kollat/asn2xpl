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

require_relative 'common'
require_relative 'specific_types'

class ASNTypeObject
    attr_accessor :type

    def initialize( type_terminator )
        @type = :undef
        @valid = false
        @hierarchical = false
        @type_terminator = type_terminator
        @tags = []
    end

    def valid?()
        return @valid
    end

    def hierarchical?()
        return @hierarchical
    end

    def parse_type( scanner )
        # First part of type
        token = scanner.get_token
        if token.type == :type 

            if token.value == "SEQUENCE"
                self.extend Sequence

            elsif token.value == "CHOICE"
                self.extend Choice

            elsif token.value == "OCTET"
                token = scanner.get_token
                if token.type == :type && token.value == "STRING"
                    self.extend OctetString
                else
                    raise ASNSyntaxError, token.value
                end 

            else
                raise ASNSyntaxError, token.value
            end

            @type = token.value.downcase.to_sym
        else
            raise ASNSyntaxError, token.value
        end

        # Possible tags
        token = scanner.get_token
        if token.type == :keyword
            if token.value == "OPTIONAL"
                @tags << token.value.downcase.to_sym
            else
                scanner.return_token token
            end
        else
            scanner.return_token token
        end

        # TODO - other parts of type declaration

        # End of type declaration
        token = scanner.get_token
        if token.type == @type_terminator
            scanner.return_token token
        end
    end

end
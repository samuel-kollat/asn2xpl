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
    attr_accessor :type, :type_terminator

    def initialize( type_terminator )
        @type = :undef
        @valid = false
        @hierarchical = false
        @anonymous = false
        @watch_anonymous = false
        @type_terminator = type_terminator
        @tags = []
    end

    def valid?()
        return @valid
    end

    def hierarchical?()
        return @hierarchical
    end

    def anonymous?()
        return @anonymous
    end

    def parse_type( scanner )
        parse_type_declaration scanner
        parse_type_tags scanner
    end

    def parse_type_declaration( scanner )
        # First part of type
        token = scanner.get_token
        if token.type == :type 

            if token.value == "SEQUENCE"
                self.extend Sequence

                token_next = scanner.get_token
                if token_next.type == :keyword && token_next.value == "OF"
                    @hierarchical = true
                    @type = :sequence_of
                elsif token_next.type == :leftcur && @watch_anonymous
                    @anonymous = true
                    scanner.return_token token_next
                    scanner.return_token token
                    @type = :anonymous
                else
                    scanner.return_token token_next
                    @type = :sequence
                end 

            elsif token.value == "CHOICE"
                self.extend Choice

                token_next = scanner.get_token
                if token_next.type == :leftcur && @watch_anonymous
                    @anonymous = true
                    scanner.return_token token_next
                    scanner.return_token token
                    @type = :anonymous
                else
                    scanner.return_token token_next
                    @type = :choice
                end 
                

            elsif token.value == "OCTET"
                token = scanner.get_token
                if token.type == :type && token.value == "STRING"
                    self.extend OctetString
                    @type = :octet_string
                else
                    raise ASNSyntaxError, token.value
                end 

            elsif token.value == "ENUMERATED"
                self.extend Enumerated
                @type = :enumerated
                get_enumeration scanner

            elsif token.value == "INTEGER"
                self.extend ASNInteger
                @type = :integer
                get_asn_integer scanner

            elsif token.value == "BOOLEAN"
                self.extend ASNBoolean
                @type = :boolean

            else
                raise ASNSyntaxError, token.value
            end
        else
            raise ASNSyntaxError, token.value
        end
    end

    def parse_type_tags( scanner )
        # Possible tags
        token = scanner.get_token
        if token.type == :keyword
            if token.value == "OPTIONAL"
                @tags << token.value.downcase.to_sym
            elsif token.value == "DEFAULT"
                @tags << token.value.downcase.to_sym
                token = scanner.get_token
                if token.type == :custom
                     @tags << token.value
                else
                    raise ASNSyntaxError, token.value
                end
            else
                scanner.return_token token
            end
        else
            scanner.return_token token
        end

        # End of type declaration
        token = scanner.get_token
        if token.type == @type_terminator || token.type == :rightcur
            scanner.return_token token
        else
            raise ASNSyntaxError, token.value
        end
    end

end
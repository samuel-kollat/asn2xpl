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

# ASN.1 Sequence
module Sequence
    def self.extended( mod )
        Debug.line("Extended: Sequence type")
    end

    def to_xpl( indent )
        if not @name.empty?
            indentation1 = create_indent(indent)
            indentation2 = create_indent(indent+1)
            puts "#{indentation1}<xpl:type name=\"#{@name}\" >"
            puts "#{indentation2}<xpl:field name=\"#{@name}_type\" type=\"UINT8\" />"
            puts "#{indentation2}<xpl:field name=\"#{@name}_length\" type=\"UINT8\" />"
        end
        @children.each do |child|
          child.to_xpl(indent+1)
        end
        if not @name.empty?
            puts "#{indentation1}</xpl:type>"
        end
    end
end

# ASN.1 Choice
module Choice
    def self.extended( mod )
        Debug.line("Extended: Choice type")
    end

    def to_xpl( indent )
        indentation1 = create_indent(indent)
        indentation2 = create_indent(indent)
        puts "#{indentation1}<xpl:record>"
        puts "#{indentation2}<xpl:field name=\"#{@name}_type\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}_length\" type=\"UINT8\" />"
        @children.each do |child|
          child.to_xpl(indent+1)
        end
        puts "#{indentation1}</xpl:record>"
    end
end

# ASN.1 Octet String
module OctetString
    def self.extended( mod )
        Debug.line("Extended: Octet String type")
    end

    def to_xpl( indent )
        indentation1 = create_indent(indent)
        indentation2 = create_indent(indent+1)
        indentation3 = create_indent(indent+2)
        puts "#{indentation1}<xpl:record>"
        puts "#{indentation2}<xpl:field name=\"#{@name}_type\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}_length\" type=\"UINT8\" >"
        puts "#{indentation3}<xpl:post>Property.#{@name}_length = #{@name}_length</xpl:post>"
        puts "#{indentation2}</xpl:field>"
        puts "#{indentation2}<xpl:field name=\"#{@name}\" type=\"String(Property.#{@name}_lenght)\" />"
        puts "#{indentation1}</xpl:record>"
    end
end

# ASN.1 Enumerated
module Enumerated
    def self.extended( mod )
        Debug.line("Extended: Enumerated type")
    end

    def get_enumeration( scanner )
        @enumeration = []

        # {
        token = scanner.get_token
        if token.type != :leftcur
            raise ASNSyntaxError, token.value
        end

        begin
            # Value
            token = scanner.get_token
            if token.type == :custom
                @enumeration << token.value
            else
                raise ASNSyntaxError, token.value
            end
            # Separator
            token = scanner.get_token
            if token.type != :comma && token.type != :rightcur
                raise ASNSyntaxError, token.value
            end
        end until token.type == :rightcur
        scanner.return_token token

        # }
        token = scanner.get_token
        if token.type != :rightcur
            raise ASNSyntaxError, token.value
        end

    end

    def to_xpl( indent )
        indentation = create_indent(indent)
        puts "#{indentation}<???>"
    end
end

# Range of Specified Type
module ASNRange
    def self.included( mod )
        Debug.line("Included: Range module")
    end

    def get_asn_range( scanner )
        @range = { min: :undef, max: :undef }

        # ( or Range does not need to be defined
        token = scanner.get_token
        if token.type != :leftpar
            scanner.return_token token
            return
        end

        # From
        token = scanner.get_token
        if token.type == :numeric
            @range[:min] = Integer(token.value)
        elsif token.type == :minrange
            @range[:min] = :min
        else
            raise ASNSyntaxError, token.value
        end

        # ..
        token = scanner.get_token
        if token.type != :range
            raise ASNSyntaxError, token.value
        end

        # To
        token = scanner.get_token
        if token.type == :numeric
            @range[:max] = Integer(token.value)
        elsif token.type == :maxrange
            @range[:max] = :max
        else
            raise ASNSyntaxError, token.value
        end

        # )
        token = scanner.get_token
        if token.type != :rightpar
            raise ASNSyntaxError, token.value
        end

    end
end

# ASN.1 Integer
module ASNInteger
    def self.extended( mod )
        Debug.line("Extended: Integer type")
    end

    include ASNRange

    def get_asn_integer( scanner )
        get_asn_range scanner
    end

    def to_xpl( indent )
        indentation1 = create_indent(indent)
        indentation2 = create_indent(indent+1)
        puts "#{indentation1}<xpl:record>"
        puts "#{indentation2}<xpl:field name=\"#{@name}_type\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}_length\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}\" type=\"UINT8\" />"
        puts "#{indentation1}</xpl:record>"
    end
  
end

# ASN.1 Boolean
module ASNBoolean
    def self.extended( mod )
        Debug.line("Extended: Boolean type")
    end

    def to_xpl( indent )
        indentation1 = create_indent(indent)
        indentation2 = create_indent(indent+1)
        puts "#{indentation1}<xpl:record>"
        puts "#{indentation2}<xpl:field name=\"#{@name}_type\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}_length\" type=\"UINT8\" />"
        puts "#{indentation2}<xpl:field name=\"#{@name}\" type=\"UINT8\" />"
        puts "#{indentation1}</xpl:record>"
    end
end

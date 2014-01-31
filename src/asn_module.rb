# ASN2XPL Compiler
# Module: ASNModule
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

require_relative 'asn_modulemember'

class ASNModule
    attr_reader :name

    def initialize()
        @name = ""
        @children = []
        @tags = []
    end

    def add_name( name )
        @name = name
    end

    def add_child( child )
        @children << child
    end

    def run( scanner )
        # Name
        token = scanner.get_token
        if token.type == :custom
            @name = token.value
        else
            raise ASNSyntaxError, token.value
        end

        # Keyword
        token = scanner.get_token
        if token.type != :keyword || token.value != "DEFINITIONS"
            raise ASNSyntaxError, token.value
        end

        # Possible TAGS
        token = scanner.get_token
        while token.type == :keyword
            @tags << token
            token = scanner.get_token
        end
        scanner.return_token token

        # ::=
        token = scanner.get_token
        if token.type != :assingment
            raise ASNSyntaxError, token.value
        end

        # Keyword
        token = scanner.get_token
        if token.type != :keyword || token.value != "BEGIN"
            raise ASNSyntaxError, token.value
        end

        # Possible ModuleMembers
        begin
            module_member = ASNModuleMember.new self, self, :leftcur
            module_member.run scanner
            module_member.empty?
            @children << module_member if module_member.valid?
        end until module_member.empty?

        # Keyword
        token = scanner.get_token
        if token.type != :keyword || token.value != "END"
            raise ASNSyntaxError, token.value
        end
        
        # End of ASN file
        token = scanner.get_token
        if token.type != :EOF
            raise ASNSyntaxError, token.value
        end
    end

    def to_xpl( indent )
        indentation = create_indent(indent)
        puts "#{indentation}<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        puts "#{indentation}<!-- BER encoding --> "
        puts "#{indentation}<xpl:module name=\"#{@name}\" xmlns:xpl=\"http://netfox.fit.vutbr.cz/2013/xplschema\">"
        @children.each do |child|
          child.to_xpl(indent+1)
        end
        puts "#{indentation}</xpl:module>"
    end

end

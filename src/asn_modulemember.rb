# ASN2XPL Compiler
# Module: ASNModuleMember
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
require_relative 'asn_member'

class ASNModuleMember < ASNMember

	def initialize( parent, root, type_terminator )
		super(parent, root, type_terminator)
	end

	def run( scanner )
		# Possible END
		token = scanner.get_token
		if token.type == :keyword && token.value == "END"
			scanner.return_token token
            return
		# Start of ModuleMember
		elsif token.type == :custom
			@empty = false
			@name = token.value
		else
			raise ASNSyntaxError, token.value
		end

		# ::=
        token = scanner.get_token
        if token.type != :assingment
            raise ASNSyntaxError, token.value
        end

        # Type
        parse_type( scanner )

        # {
        token = scanner.get_token
        if token.type != :leftcur
            raise ASNSyntaxError, token.value
        end

        # Possible Members
        begin
            member = ASNMember.new self, @root, :comma
            member.run scanner
            @children << member if member.valid?
        end until member.empty?

        # }
        token = scanner.get_token
        if token.type != :rightcur
            raise ASNSyntaxError, token.value
        end

        # ModuleMember successfully read
        @valid = true
	end

end
# ASN2XPL Compiler
# Module: ASNMember
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
require_relative 'asn_typeobject'

class ASNMember < ASNTypeObject
	attr_reader :parent, :root

	def initialize( parent, root, type_terminator )
		super(type_terminator)
		@name = ""
		@parent = parent
		@root = root
		@empty = true
		@children = []
	end

	def run( scanner )
		# Possible END
		token = scanner.get_token
		if token.type == :rightcur
			scanner.return_token token
            return
		# Start of Member
		elsif token.type == :custom
			@empty = false
			@name = token.value
		else
			raise ASNSyntaxError, token.value
		end

		# Type and possible hierarchy
		@watch_anonymous = true	# type is eg. SEQUENCE { ... }
        parse_type_declaration( scanner )
        if hierarchical? || anonymous?
        	hierarchical_member = ASNMember.new self, @root, :leftcur
        	hierarchical_member.run_hierarchical scanner
        	@children << hierarchical_member if hierarchical_member.valid?
        end
        parse_type_tags( scanner )

        # , or }
        token = scanner.get_token
        if token.type != :comma && token.type != :rightcur
        	raise ASNSyntaxError, token.value
        end

        # End of member and its parent
        if token.type == :rightcur
        	scanner.return_token token
        end

        @valid = true
	end

	def run_hierarchical( scanner )
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

        # Successfully read
        @valid = true
	end

	def empty?()
		return @empty
	end

end
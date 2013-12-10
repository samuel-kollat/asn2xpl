# ASN2XPL Compiler
# Module: ASNPair
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class ASNPair
	attr_reader :name, :parent

  @@syntax = [:custom, :basic_type]
  # Table:        ASN Type         Code       Length    Value
  @@xpl_types = { "integer" =>    ["UInt8",   "UInt8",  "UInt8"],
                  "ia5string" =>  ["UInt8",   "UInt8",  "String"],
                  "boolean" =>    ["UInt8",   "UInt8",  "UInt8"],
                }
  @@xpl_pair_number = 0

	def initialize( name, parent, type, state=0 )
		@name = name
		@type = []
    @type << type
    @state = state  # Syntax analysis start
    @parent = parent
	end

	def add_type( type )
		@type << type
	end

  def closed?()
    @state >= @@syntax.size
  end

  def add( token )
    successor = self

    if(token.type == @@syntax[@state])
			syntax_error = case @state
			when 0
				@name = token.value
				false
			when 1
        add_type(token.value.downcase)
        false
			else
				true
			end
			@state += 1
		else
			syntax_error = true
		end

		if(syntax_error)
			raise ASNSyntaxError, token.value
		end

    return successor
  end

	def to_xpl( indent )
    indentation = create_indent(indent)
    @@xpl_pair_number += 1

    puts "#{indentation}<xpl:field name=\"#{@type[0].capitalize}#{@@xpl_pair_number}\" type=\"#{@@xpl_types[@type[0].downcase][0]}\"/>"
    puts "#{indentation}<xpl:field name=\"#{@type[0].capitalize}#{@@xpl_pair_number}Length\" type=\"#{@@xpl_types[@type[0].downcase][1]}\"/>"
		puts "#{indentation}<xpl:field name=\"#{@name}\" type=\"#{@@xpl_types[@type[0].downcase][2]}\"/>"
	end

end

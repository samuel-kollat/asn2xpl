# ASN2XPL Compiler
# Module: Common
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class Debug

	@@enabled = true

	def self.method_missing( method, *arguments )
		if(@@enabled)
			DebugPrint.send(method, *arguments)
		end
	end

end

class DebugPrint

	def self.section( line )
		puts "\n**********"
		puts line
		puts "**********"
		puts
	end

	def self.header( header )
		puts "== #{header} =="
	end

	def self.line( line )
		puts "\t#{line.to_s}"
	end

end

class ASNSyntaxError < Exception
end

def create_indent( indent )
  indentation = ""
  (0..indent-1).each do
    indentation += "  "
  end
  return indentation
end

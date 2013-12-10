# ASN2XPL Compiler
# Module: Generator
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class Generator

  def initialize( ast )
    @ast = ast
  end

  def run( encoding )
    case encoding
    when :ber
      @ast.to_xpl(0)
    else
      puts "Encoding not supported yet."
    end
  end
end

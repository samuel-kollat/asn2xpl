# ASN2XPL Compiler
# Module: ASNMetastabile
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class Metastabile

  @@syntax = [:custom, :assingment, :constructed_type]

  def initialize()
    @name = ""
    @state = 0
  end

  def add( token, parent )
    stabile_object = nil

    if(token.type == @@syntax[@state])
      syntax_error = case @state
      when 0
        @name = token.value
        false
      when 1
        false
      when 2
        if(token.value == "SEQUENCE")
          stabile_object = ASNSequence.new @name, parent
          false
        else
          true
        end
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

    return stabile_object
  end

end

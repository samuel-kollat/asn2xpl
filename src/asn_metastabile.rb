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

  @@syntax1 = [:custom, :assingment, :constructed_type]
  @@syntax2 = [:custom, :basic_type]

  def initialize()
    @name = ""
    @state = 0
  end

  def add( token, parent )
    stabile_object = nil
    syntax_error1 = true
    syntax_error2 = true

    if(token.type == @@syntax1[@state])
      syntax_error1 = case @state
      when 0
        @name = token.value
        false
      when 1
        false
      when 2
        if(token.value == "SEQUENCE")
          stabile_object = ASNSequence.new @name, parent, 3
          false
        else
          true
        end
      else
        true
      end
    end
    
    if(token.type == @@syntax2[@state])
      syntax_error2 = case @state
      when 0
        @name = token.value
        false
      when 1
        stabile_object = ASNPair.new @name, parent, token.value, 2
        false
      else
        true
      end

    end
    
    if(syntax_error1 and syntax_error2)  
      raise ASNSyntaxError, token.value
    end

    @state += 1
    return stabile_object
  end

end

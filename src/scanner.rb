# ASN2XPL Compiler
# Module: Scanner
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2014
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class Token
    attr_reader :value, :type

    @@keywords = %w(DEFINITIONS BEGIN END OPTIONAL SIZE FROM WITH COMPONENTS \
                    ABSENT OF AUTOMATIC TAGS)
    @@types = %w(BOOLEAN NULL INTEGER REAL ENUMERATED BIT OCTET STRING \
        OBJECT IDENTIFIER RELATIVE-OID EXTERNAL EMBEDDED PDV CHARACTER UTCTIME \
        GENERALIZEDTIME IA5String CHOICE SEQUENCE SET)

    def initialize( lexeme )
        @value = lexeme
        @type = get_type(lexeme)
    end

    private

    def get_type( lexeme )
        if lexeme == :EOF
            :EOF
        elsif @@keywords.include? lexeme
            :keyword
        elsif @@types.include? lexeme
            :type
        else
            case lexeme
            when "::="
                :assingment
            when "("
                :leftpar
            when ")"
                :rightpar
            when "["
                :leftsqu
            when "]"
                :rightsqu
            when "{"
                :leftcur
            when "}"
                :rightcur
            when ","
                :comma
            else
                :custom
            end
        end
    end
end

class Scanner
    attr_reader :line_number

    def initialize( file )
        @input_file = file
        @opened_file = File.open(@input_file, 'r')
        @cached_tokens = []
        @line_number = 0
    end

    def get_token()
        if @cached_tokens.empty?
            begin
                begin 
                    line = @opened_file.readline
                    @line_number += 1
                    # remove comments
                    relevant_line = line.strip.gsub(/--.*/, "")
                end while relevant_line.empty?
                # spaces aroud commas, brackets and dots
                preprocessed_line = relevant_line.gsub(/,/, " , ")
                preprocessed_line = preprocessed_line.gsub(/([\(\)\[\]\{\}])/, ' \1 ')
                preprocessed_line = preprocessed_line.gsub(/(\.+)/, ' \1 ')
                # tokenizing
                preprocessed_line.split.each do |lexeme|
                    #Debug.line(lexeme)
                    @cached_tokens.push Token.new lexeme
                end
            rescue EOFError
                @cached_tokens.push Token.new :EOF
            end
        end
        @cached_tokens.delete_at(0)
    end

    def return_token( token )
        @cached_tokens.push token
    end

end # Class Scanner

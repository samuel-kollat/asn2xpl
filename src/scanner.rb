# ASN2XPL Compiler
# Module: Scanner
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

class Token
	attr_reader :value, :type

	@@keywords = %w(DEFINITIONS BEGIN END OPTIONAL SIZE FROM WITH COMPONENTS ABSENT)
	@@basic_types = %w(BOOLEAN NULL INTEGER REAL ENUMERATED BIT OCTET STRING \
		OBJECT IDENTIFIER RELATIVE-OID EXTERNAL EMBEDDED PDV CHARACTER UTCTIME GENERALIZEDTIME)
	@@constructed_types = %w(CHOICE SEQUENCE SET OF)

	def initialize( lexeme )
		@value = lexeme
		@type = get_type(lexeme)
	end

	private

	def get_type( lexeme )
		if @@keywords.include? lexeme.upcase
			:keyword
		elsif @@basic_types.include? lexeme.upcase
			:basic_type
		elsif @@constructed_types.include? lexeme.upcase
			:constructed_type
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
			else
				:custom
			end
		end
	end
end

class Scanner

	def initialize( file )
		@input_file = file
	end

	def each_token()
		File.open(@input_file, 'r') do |f|
			f.each_line do |line|
				# remove comments
				relevant_line = line.strip.gsub(/--.*/, "")
				# commas to spaces, spaces aroud brackets and dots
				preprocessed_line = relevant_line.gsub(/,/, " ")
				preprocessed_line = preprocessed_line.gsub(/([\(\)\[\]\{\}])/, ' \1 ')
				preprocessed_line = preprocessed_line.gsub(/(\.+)/, ' \1 ')
				# tokenizing
				preprocessed_line.split.each do |lexeme|
					token = Token.new lexeme
					yield token
				end
			end
		end
	end


end # Class Scanner

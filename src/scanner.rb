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

	@@keywords = %w(DEFINITIONS BEGIN END SEQUENCE INTEGER BOOLEAN)

	def initialize( lexeme )
		@value = lexeme
		@type = get_type(lexeme)
	end

	private

	def get_type( lexeme )
		if @@keywords.include? lexeme.upcase
			:keyword
		else
			case lexeme
			when "::="
				:assingment
			when "{"
				:leftbr
			when "}"
				:rightbr
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
				# commas to spaces
				preprocessed_line = relevant_line.gsub(/,/, " ")
				# tokenizing
				preprocessed_line.split.each do |lexeme|
					token = Token.new lexeme
					yield token
				end
			end
		end
	end


end # Class Scanner
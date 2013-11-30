# ASN2XPL Compiler
#
# Samuel Kollat <xkolla04@stud.fit.vutbr.cz>
#
# 2013
#
# ASN.1 to XPL compilation
# Input is a valid ASN.1 specification of a network protocol.
# Output is a valid XPL document that takes into account particular
# data encoding (BER, PER, ...)

require 'optparse'
require_relative 'parser'
require_relative 'common'

class OptParser
  attr_reader :encoding_options, :input_file, :option_parser

  def initialize()
    @encoding_options = {}
    @input_file = nil
  end

  def parse( args )
    @option_parser = OptionParser.new do |opts|

      opts.banner = "Usage: asn2xpl.rb [options]"

      opts.on("-b", "--ber", "BER encoding") do |e|
        @encoding_options[:ber] = e
      end
      
      opts.on("-p", "--per", "PER encoding") do |e|
        @encoding_options[:per] = e
      end

      opts.on("-f", "--file FILE",
              "Require the ASN.1 FILE") do |f|
        @input_file = f
      end

      opts.on("-h", "--help", "Display help message") do
        puts opts
        exit
      end
    end

    option_parser.parse!(args)
    check_encodings
    check_input_file
  end

  def check_encodings()
    err_string = "At least one encoding must be specified."
    raise OptionParser::InvalidOption, err_string if @encoding_options.size == 0  
  end

  def check_input_file()
    err_string = "Input ASN.1 file must be specified."
    raise OptionParser::InvalidOption, err_string if @input_file.nil?
  end

end # Class OptParser


class Asn2Xpl

  def initialize()
    @opts = OptParser.new
    get_options
  end

  def print_user_options()
    Debug.section("General information")

    head_string = "Selected encoding"
    head_string << "s" if @opts.encoding_options.count > 1
    Debug.header(head_string)

    @opts.encoding_options.each() do |key, value|
      Debug.line(key) if value
    end

    Debug.header("Input file")
    Debug.line( @opts.input_file.slice( @opts.input_file.rindex("/")+1..-1 ) )
  end

  def parse()
    Debug.section("Parsing input ASN.1 file.")

    parser = Parser.new @opts.input_file
    parser.run
  end

  def generate()
    @opts.encoding_options.each_key() do |encoding|
      Debug.section("Genrating XPL code for #{encoding.to_s} encoding.")
    end
  end

private

  def get_options()
    begin
      @opts.parse(ARGV)
    rescue OptionParser::InvalidOption => e
      puts e
      puts @opts.option_parser
      exit 1
    end  
  end

end

asn2xpl = Asn2Xpl.new
asn2xpl.print_user_options

asn2xpl.parse
asn2xpl.generate

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

class OptParser

  attr_reader :options, :option_parser

  def initialize()

    @options = {}

  end

  def parse( args )
    
    @option_parser = OptionParser.new do |opts|

      opts.banner = "Usage: asn2xpl.rb [options]"

      opts.on("-b", "--ber", "BER encoding") do |e|
        options[:ber] = e
      end
      
      opts.on("-p", "--per", "PER encoding") do |e|
        options[:per] = e
      end

      opts.on("-h", "--help", "Display help message") do
        puts opts
        exit
      end

    end

    option_parser.parse!(args)

    check_encodings

  end

  def check_encodings()

    err_string = "At least one encoding must be specified."
    raise OptionParser::InvalidOption, err_string if @options.count == 0
     
  end

end # Class OptParser


class Asn2Xpl

  def initialize()

    @opts = OptParser.new
    get_options

  end

  def print_user_options()
    
    head_string = "Selected encoding"
    head_string << "s" if @opts.options.count > 1
    puts "#{head_string}:"

    @opts.options.each() do |key, value|
      puts "#{key.to_s}" if value
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

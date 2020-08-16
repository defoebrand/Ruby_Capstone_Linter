require 'strscan'

class LintFile
  attr_reader :scan_file, :file_lines
  def initialize(filepath)
    @scan_file = File.open(filepath)
    @file_lines = []
  end

  def read_lines
    @scan_file.each_with_index do |line, ind|
      @file_lines[ind] = StringScanner.new(line)
    end
  end
end

@filepath = './bad_code.rb'
# filepath = './good_code.rb'
# filepath = gets.chomp

@error_hash = {
  'Trailing Whitespace Detected' => [],
  'Excess Whitespace Detected' => [],
  'Extraneous Empty Line Detected' => [],
  'Indentation Error Detected' => [],
  'Missing Empty Line Detected' => [],
  'Missing Closing Statement Detected' => [],
  'Missing Final Closing Statement Detected' => [],
  'Incorrect Capitalization of Reserved Word Detected' => [],
  'Missing { Detected' => [],
  'Missing } Detected' => [],
  'Missing ( Detected' => [],
  'Missing ) Detected' => [],
  'Missing [ Detected' => [],
  'Missing ] Detected' => []
}

@tags_hash = {
  '\{' => '\}',
  '\(' => '\)',
  '\[' => '\]'
}

@reserved_words = [/class/i, /def/i, /if/i, /do/i]
# @block_word_reg = [/def/i, /if/i, /do/i]

@indent = 0

@found_def = false
@found_end = false
@def_block = []

@open_block = 0
@close_block = 0

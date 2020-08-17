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

@error_hash = {
  'Trailing Whitespace Detected' => [],
  'Excess Whitespace Detected' => [],
  'Extraneous Empty Line Detected' => [],
  'Missing Empty Line Detected' => [],
  'Indentation Error Detected' => [],
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

@reserved_words = [/def/i, /if/i, /do/i, /class/i]

@block_start = false
@block_end = false
@reserved_word_count = 0
@nest_count = 0
@indent = 0

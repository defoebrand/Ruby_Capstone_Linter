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

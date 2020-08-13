require 'strscan'

class ReadFile
  attr_reader :file_to_check
  def initialize(filepath)
    @file_to_check = File.open(filepath)
  end
end
# spec/linter_tester.rb

require_relative '../lib/file_checker.rb'

describe Enumerable do
  let(:empty_array) { [] }
  let(:test_file) { LintFile.new('./bad_code.rb') }
  let(:file_lines) { test_file.file_lines }
  let(:error_hash) { @error_hash }
  let(:res_words) { test_file.reserved_words }
  let(:original_file) { File.open('./bad_code.rb') }

  # = = = file_reader tests = = = = =

  describe '#LintFile class initialize' do
    it 'returns a file instance' do
      expect(test_file.scan_file.class).to eql(File.open('./bad_code.rb').class)
    end
    it "returns a unique instance of an open file as when using Ruby's File class" do
      expect(test_file.scan_file).not_to eql(File.open('./bad_code.rb'))
    end
  end

  describe '#LintFile read_lines' do
    it 'returns an array' do
      test_file.read_lines
      expect(file_lines.class).to eql(Array)
    end
    it 'returns an array of scanned strings' do
      test_file.read_lines
      expect(file_lines[0].class).to eql(StringScanner)
    end
    it 'returns an array with the same length as the number of lines in the test file' do
      test_file.read_lines
      expect(file_lines.count).to eql(original_file.count)
    end
    it 'returns an array of strings that matches one opened with #File' do
      sample = (rand * 10).to_i
      test_file.read_lines
      expect(file_lines[sample].string).to eql(original_file.readlines[sample])
    end
  end

  # = = = file_checker tests = = = = =

  # = = # = = final_closing_statement = = # = = #

  describe 'file_checker #capture_block' do
    # it 'returns true if the end of a document has been reached and there are more opening reserved words than corresponding end statements' do
    #   open_linter('./bad_code.rb')
    #   expect(@error_hash['Missing Final Closing Statement Detected'].include?(29)).to eql(true)
    # end
    it 'returns false unless the end of a document has been reached and there are more opening reserved words than corresponding end statements' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing Final Closing Statement Detected'].include?(13)).not_to eql(true)
    end
  end
  # = = # = = capture_block = = # = = #

  describe 'file_checker #capture_block' do
    it 'returns true if a method block is nested inside another method block' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing Closing Statement Detected'].include?(12)).to eql(true)
    end
    it 'returns false unless a method block is nested inside another method block' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing Closing Statement Detected'].include?(13)).not_to eql(true)
    end
  end
  # = = # = = check_whitespaces = = # = = #

  describe 'file_checker #check_whitespaces' do
    # it 'returns true if a line has more than one space between words' do
    #   open_linter('./bad_code.rb')
    #   expect(@error_hash['Excess Whitespace Detected'].include?(14)).to eql(true)
    # end
    it 'returns false unless a line has more than one space between words' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Excess Whitespace Detected'].include?(12)).not_to eql(true)
    end
    it 'returns true if a line has one or more spaces between the last character and the end of the line' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Trailing Whitespace Detected'].include?(16)).to eql(true)
    end
    it 'returns false unless  a line has one or more spaces between the last character and the end of the line' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Trailing Whitespace Detected'].include?(19)).not_to eql(true)
    end
  end

  # = = # = = check_for_extra_lines = = # = = #

  describe 'file_checker #check_for_extra_lines' do
    it "returns true if a line isn't expected to be empty but is" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Extraneous Empty Line Detected'].include?(3)).to eql(true)
    end
    it "returns false unless a line isn't expected to be empty and is" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Extraneous Empty Line Detected'].include?(4)).not_to eql(true)
    end
  end

  # = = # = = check_for_missing_lines = = # = = #

  describe 'file_checker #check_for_missing_lines' do
    it "returns true if a line is expected to be empty but isn't" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing Empty Line Detected'].include?(10)).to eql(true)
    end
    it 'returns false if a line is expected to be empty and is' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing Empty Line Detected'].include?(9)).not_to eql(true)
    end
  end

  # = = # = = check_indentation = = # = = #

  describe 'file_checker #check_indentation' do
    it "returns true if a line is found with incorrent indentation based on it's nested position" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Indentation Error Detected'].include?(1)).to eql(true)
    end
    it "returns false unless a line is found with incorrent indentation based on it's nested position" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Indentation Error Detected'].include?(2)).not_to eql(true)
    end
    it "returns true if a line is found with incorrent indentation based on it's nested position" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Indentation Error Detected'].include?(27)).to eql(true)
    end
    it "returns false unless a line is found with incorrent indentation based on it's nested position" do
      open_linter('./bad_code.rb')
      expect(@error_hash['Indentation Error Detected'].include?(28)).not_to eql(true)
    end
  end

  # = = # = = check_tags = = # = = #

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched { bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing { Detected'].include?(17)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched { bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing { Detected'].include?(16)).not_to eql(true)
    end
  end

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched } bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing } Detected'].include?(16)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched } bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing } Detected'].include?(17)).not_to eql(true)
    end
  end

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched [ bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing [ Detected'].include?(2)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched [ bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing [ Detected'].include?(7)).not_to eql(true)
    end
  end

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched ] bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ] Detected'].include?(7)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched ] bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ] Detected'].include?(2)).not_to eql(true)
    end
  end

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched ( bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ( Detected'].include?(26)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched ( bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ( Detected'].include?(25)).not_to eql(true)
    end
  end

  describe 'file_checker #check_tags' do
    it 'returns true if a line is found with a mismatched ) bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ) Detected'].include?(25)).to eql(true)
    end
    it 'returns false unless a line is found with a mismatched ) bracket' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Missing ) Detected'].include?(26)).not_to eql(true)
    end
  end

  # = = # = = check_capitalization = = # = = #

  describe 'file_checker #check_capitalization' do
    it 'returns true if a line is found with capitalization of a reserved word not in all lowercase' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Incorrect Capitalization of Reserved Word Detected'].include?(1)).to eql(true)
    end
    it 'returns false unless a line is found with capitalization of a reserved word not in all lowercase' do
      open_linter('./bad_code.rb')
      expect(@error_hash['Incorrect Capitalization of Reserved Word Detected'].include?(2)).not_to eql(true)
    end
  end

  # = = = ruby_linter tests = = = = =

  describe 'file_checker #check_capitalization' do
    it 'returns true if a line is found with capitalization of a reserved word not in all lowercase' do
      open_linter('./bad_code.rb')
      expect(@error_hash.values.flatten.count).to eql(16)
    end
    it 'returns false unless a line is found with capitalization of a reserved word not in all lowercase' do
      open_linter('./bad_code.rb')
      expect(@error_hash.values.flatten.count).not_to eql(15)
    end
  end
end

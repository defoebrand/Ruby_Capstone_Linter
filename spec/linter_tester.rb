# spec/enumerable_test.rb

require './lib/file_checker.rb'

describe Enumerable do
  let(:empty_array) { [] }

  let(:test_file){ LintFile.new('./bad_code.rb')}
  let(:file_lines){test_file.file_lines}
  let(:error_hash){@error_hash}
  let(:res_words){test_file.reserved_words}
  
  describe '#LintFile initialize' do
    it "returns an open file as when using Ruby's File class" do
      expect(test_file.scan_file.class).to eql(File.open('./bad_code.rb').class)
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
      expect(file_lines.count).to eql(41)
    end
  end
  
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
  
  
    
  # describe '#my_each' do
  #   it 'return matches that of #each enumerable with numeric array' do
  #     expect(num_array.my_each { num_array_test_block }).to eql(num_array.each { num_array_test_block })
  #   end
  #
  #   it 'return matches that of #each enumerable with string hash' do
  #     expect(str_hash.my_each { str_hash_test_block }).to eql(str_hash.each { str_hash_test_block })
  #   end
  # end
  #
  # describe '#my_each_with_index' do
  #   it 'return matches that of #each_with_index enumerable with numeric array' do
  #     expect(num_array.my_each_with_index do
  #              num_array_test_block
  #            end).to eql(num_array.each_with_index { num_array_test_block })
  #   end
  #
  #   it 'return matches that of #each_with_index enumerable with numeric array plus index' do
  #     expect(num_array.my_each_with_index do
  #              num_array_ind_test_block
  #            end).to eql(num_array.each_with_index { num_array_ind_test_block })
  #   end
  #
  #   it 'return matches that of #each enumerable with string hash' do
  #     expect(str_hash.my_each_with_index do
  #              str_hash_test_block
  #            end).to eql(str_hash.each_with_index { str_hash_test_block })
  #   end
  # end
end

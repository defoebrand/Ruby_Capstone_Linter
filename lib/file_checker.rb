require './lib/file_reader'

def file_array
  
  open = ReadFile.new('./bad_code.rb')
  # open = ReadFile.new(gets.chomp)
  scan_file = open.file_to_check
  # p file_name
  contents_array = []
  scan_file.each_with_index do |line, ind|
    contents_array[ind] = StringScanner.new(line)
    puts line
    # sleep(1)
  end
end

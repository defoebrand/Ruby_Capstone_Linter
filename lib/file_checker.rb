require './lib/file_reader'
require 'pry'

def check_file(filepath = nil)
  open = ReadFile.new('./bad_code.rb')
  # open = ReadFile.new('./good_code.rb')
  # open = ReadFile.new(filepath)
  scan_file = open.file_to_check
  contents_array = []
  error_array = []
  
  scan_file.each_with_index do |line, ind|
    contents_array[ind] = StringScanner.new(line)
    # puts line
    # sleep(1)
  end
  

    contents_array.length.times do |ind|
      if contents_array[ind].rest.include?("\n") && !contents_array[ind].rest.match?(/\w+/)
        if  contents_array[ind-1].rest.include?("\n") && !contents_array[ind-1].rest.match?(/\w+/)
          puts "error at line #{ind + 1}: extra line detected".cyan
        end
      end    
      if contents_array[ind].rest[-2] == " "
        puts "error at line #{ind + 1}: trailing whitespace detected".magenta
      end
      if contents_array[ind].rest.match?(/\w+\s\s\w+/)
        puts "error at line #{ind + 1}: excess whitespace detected".yellow
      end
      if contents_array[ind].rest.match?(/^\s*def/)
        unless contents_array[ind+1].rest.match(/^\s{2}\w+/)
          puts "error at line #{ind+2}: improper indentation detected".green
        end
        if contents_array[ind+1].rest.include?("\n") && !contents_array[ind+1].rest.match?(/\w+/)
          puts "error at line #{ind+2}: extra line detected".blue
        end
      end
      if contents_array[ind].rest.match?(/^[#\s]*end$/)
        if contents_array[ind-1].rest.include?("\n") && !contents_array[ind-1].rest.match?(/\w+/)
          puts "error at line #{ind}: extra line detected".white
        end
        if contents_array[ind+1].rest.include?("\n") && contents_array[ind+1].rest.match?(/\w+/) && !contents_array[ind+1].rest.match?(/^[#\s]*end$/)
          puts "error at line #{ind+1}: missing empty line".red
        end
      end
    end
      
      
  end


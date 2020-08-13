require './lib/file_reader'

def file_array
  open = ReadFile.new('./bad_code.rb')
  # open = ReadFile.new(gets.chomp)
  scan_file = open.file_to_check
  contents_array = []
  empty_lines = []
  each_line = []
  
  scan_file.each_with_index do |line, ind|
    contents_array[ind] = StringScanner.new(line)
    # puts line
    # sleep(1)
    
    each_line << contents_array[ind].string

    if line == "\n"
      empty_lines << ind
    end
      
    if contents_array[ind].rest[-2] == " "
      puts "error at line #{ind + 1}: trailing whitespace detected".magenta
    end

    if contents_array[ind].rest.match?(/\w+\s\s\w+/)
      puts "error at line #{ind + 1}: excess whitespace detected".yellow
    end
  end
    
    empty_lines.each_with_index do |line_num, ind|
      if empty_lines[ind] + 1 == empty_lines[ind + 1]
        puts "error at line #{empty_lines[ind + 1]}: extra line detected".cyan
      end
    end

    each_line.length.times do |ind|
      if each_line[ind].match?(/^\s*def/)
        unless each_line[ind+1].match(/^\s{2}\w+/)
          puts "error at line #{ind+1}: improper indentation detected".green
        end
        if each_line[ind+1].include?("\n") && !each_line[ind+1].match?(/\w+/)
          puts "error at line #{ind}: extra line detected".blue
        end
      end
      if each_line[ind].match?(/^[#\s]*end$/)
        if each_line[ind-1].include?("\n") && !each_line[ind-1].match?(/\w+/)
          puts "error at line #{ind}: extra line detected".white
        end
        if each_line[ind+1].include?("\n") && !each_line[ind+1].match?(/\w+/)
          puts "error at line #{ind+2}: missing empty line".red
        end
      end
    end
      
      
  end


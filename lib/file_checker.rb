require './lib/file_reader'
require 'colorize'
require 'pry'

def check_for_errors(filepath = nil)
  @current_file = LintFile.new(filepath)
  @current_file.read_lines
  @error_hash = {
    line_nums: {},
    errors: { whitespace_errors: [],
              empty_line_errors: [],
              line_indentation_errors: [],
              closing_errors: [],
              tag_errors: [] }
  }
  @indent_spaces = 3
  @reserved_word = %w[end do elsif else def class]
  @found_def = false
  @found_end = false
  @def_block = []
  @indent_blocks = []

  @current_file.file_lines.length.times do |line_num|
    check_whitespaces(line_num)
    check_for_extra_lines(line_num)
    check_for_missing_lines(line_num)
    # capture_block(line_num)

    # check_indentation(line_num)
    check_tags(line_num)
  end
end

def check_whitespaces(line_num)
  if @current_file.file_lines[line_num].rest.match?(/\S/)
    if @current_file.file_lines[line_num].rest.match?(/\s{1,}\n/)

      puts "error at line #{line_num + 1}: trailing whitespace detected".magenta
    end
  end
  if @current_file.file_lines[line_num].rest.match?(/\w+\s{2,}\w+/)
    puts "error at line #{line_num + 1}: excess whitespace detected".yellow
  end
end

def check_for_missing_lines(line_num)
  if @current_file.file_lines[line_num].rest.match?(/^[#\s]*end/)
    if @current_file.file_lines[line_num + 1].rest.match?(/\w+/) &&
       !@current_file.file_lines[line_num + 1].rest.match?(/^[#\s]*end$/)
      puts "error at line #{line_num + 1}: missing empty line detected".red
    end
  end
end

def check_for_extra_lines(line_num)
  if @current_file.file_lines[line_num].rest.match?(/\w+/) &&
     !@current_file.file_lines[line_num].rest.match?(/\bend\b/)
    unless @current_file.file_lines[line_num + 1].rest.match?(/\w+/)
      puts "error at line #{line_num + 2}: extraneous empty line detected".cyan
    end
  end
  if !@current_file.file_lines[line_num].rest.match?(/\w+/) &&
     !@current_file.file_lines[line_num - 1].rest.match?(/\w+/)
    puts "error at line #{line_num + 1}: extraneous empty line detected".cyan
  end
end

def capture_block(line_num)
  if @found_end == true
    @found_end = false
    @found_def = false
    check_indentation(line_num)
    @def_block = []
  elsif @current_file.file_lines[line_num].rest.match?(/def/)
    start_def_block(line_num)
  elsif @found_def == true
    end_def_block(line_num)
  end
end

def check_indentation(line_num = nil)
  if @current_file.file_lines[line_num].rest.match?(/def/) ||
     @current_file.file_lines[line_num].rest.match?(/end/)
    if !@current_file.file_lines[line_num].rest.match?(/^\s{2}\w+/) == true
      p @current_file.file_lines[line_num].rest # .split('')
      p !@current_file.file_lines[line_num].rest.match?(/^\s{2}\w+/)
      puts "error at line #{line_num + 1}".magenta unless line_num == @current_file.file_lines.length - 1
    end
  elsif !@current_file.file_lines[line_num].rest.match?(/^\s{4}\w+/) == true
    puts "error at line #{line_num + 1}".magenta
  end
  # if @current_file.file_lines[line_num].rest.match?(/\w+/) &&
  #    !@current_file.file_lines[line_num].rest.match?(/\bend\b/)

  # p @def_block
  #
  # ind = @def_block.length
  # p line_num
  # p ind
  #
  # test = @def_block.select { |x| x.match?('def') || x.match?('end') }
  # p test
  # test2 = @def_block.select { |x| !x.match?('def') && !x.match?('end') }
  # p test2
  # p @def_block
  # binding.pry
  # @def_block.length.times do |ind|
  # unless @def_block[ind].match(/^\s{2}\w+/)
  # puts @def_block[ind] # unless @def_block[ind]
  # end
  # if @def_block[ind].match?(/def/) || @def_block[ind].match?(/end/) && !@def_block[ind].match(/^\s{2}\w+/)
  #   puts @def_block[ind]
  #   puts "error on line #{line_num}"
  # end
  # p "error on def line #{line_num}"
  # elsif @def_block[ind].match?(/end/) && !@def_block[ind].match(/^\s{2}\w+/)
  #   p "error on end line #{line_num}"
  # else
  #   p "error on method interior line #{line_num}" unless @def_block[ind].match(/^\s{4}\w+/)

  # p @def_block[ind] unless @def_block[ind].match(/^\s{2}\w+/)

  # binding.pry
  # p @def_block[ind].split('') # .select { |x| x == ' ' }.length
  # space saver
  # end
end

def start_def_block(line_num)
  if @found_def == true
    puts "error on line #{line_num}: missing closing statement detected".light_black
    @found_end = false
    @found_def = false
    check_indentation(line_num)
    @def_block = []
  else
    check_indentation(line_num)
    @found_def = true
    @def_block << @current_file.file_lines[line_num].rest
    capture_block(line_num + 1)
  end
end

def end_def_block(line_num)
  if @current_file.file_lines[line_num].rest.match?(/end/)
    @found_end = true
    @def_block << @current_file.file_lines[line_num].rest
    check_indentation(line_num)
    capture_block(line_num)
  else
    @def_block << @current_file.file_lines[line_num].rest
    check_indentation(line_num)
    capture_block(line_num + 1)
  end
end

def check_tags(line_num)
  if @current_file.file_lines[line_num].check_until(/[^\"\']\{[^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\}[^\"\']/)
      puts "error on line #{line_num + 1}: missing '}' detected".magenta
    end
  elsif @current_file.file_lines[line_num].check_until(/[^\"\']\}[^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\{[^\"\']/)
      puts "error on line #{line_num + 1}: missing '{' detected".magenta
    end
  elsif @current_file.file_lines[line_num].check_until(/[^\"\']\[[^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\][^\"\']/)
      puts "error on line #{line_num + 1}: missing ']' detected".magenta
    end
  elsif @current_file.file_lines[line_num].check_until(/[^\"\']\][^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\[[^\"\']/)
      puts "error on line #{line_num + 1}: missing '[' detected".magenta
    end
  elsif @current_file.file_lines[line_num].check_until(/[^\"\']\([^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\)[^\"\']/)
      puts "error on line #{line_num + 1}: missing ')' detected".magenta
    end
  elsif @current_file.file_lines[line_num].check_until(/[^\"\']\)[^\"\']/)
    unless @current_file.file_lines[line_num].check_until(/[^\"\']\([^\"\']/)
      puts "error on line #{line_num + 1}: missing '(' detected".magenta
    end
  end
end

#   # binding.pry
#   if @found_def == true
#     # unless @found_end == true
#     @def_block << @current_file.file_lines[line_num].rest
#     if @current_file.file_lines[line_num].rest.match?(/^\s*end/)
#       # @def_block << @current_file.file_lines[line_num].rest
#       @indent_blocks << @def_block
#
#       p @indent_blocks
#     else
#       # @def_block << @current_file.file_lines[line_num].rest
#       check_indentation(line_num + 1)
#     end
#   # end
#   else
#     if @current_file.file_lines[line_num].rest.match?(/^\s*def/)
#       @def_block << @current_file.file_lines[line_num].rest
#       @found_def = true
#       check_indentation(line_num + 1)
#     end
#   end
#   @found_def = false
#   @found_end = false
# end
# test = 2
# if @found_def == false
#   if @current_file.file_lines[line_num].rest.match?(/^\s*def/)
#     @found_def = true
#     check_indentation(line_num + 1)
#   end
#   if @found_def == true
#     if @current_file.file_lines[line_num].rest.match?(/^\s*end/)
#       break
#     else
#       unless @current_file.file_lines[line_num].rest.match(/^\s{2}\w+/)
#         puts "error at line #{line_num + 2}: improper line indentation detected".green
#       end
#       check_indentation(line_num + 1)
#     end
#   end
# end

#   line_num += 1
#   p 'found a def'
#   p @current_file.file_lines[line_num + 1].check_until(/end/)
# else

# unless @current_file.file_lines[line_num + 1].rest.split.any?(@reserved_word)
# @current_file.file_lines[line_num + 1].rest.match(/^\s{3}\w+/)
# puts "error at line #{line_num + 2}: improper line indentation detected".green
# end
# end
# end

# @current_file.file_lines.length.times do |line|
#
#   if @current_file.file_lines[line].rest.include?("\n") && !@current_file.file_lines[line].rest.match?(/\w+/)
#
#     if  @current_file.file_lines[line-1].rest.include?("\n") && !@current_file.file_lines[line-1].rest.match?(/\w+/)
#       # @error
#       @error_hash[:errors][:empty_line_errors] << "Error at line #{line + 1}: #{@current_file.file_lines[line+1].scan_until(/\s$/)}" #adjust regex
#     end
#   end
#
#
#   if @current_file.file_lines[line].rest[-2] == " "
#     @error_hash[:line_nums]["Line #{line + 1}"] = ['whitespace error: ' + "#{@current_file.file_lines[line+1].scan_until(/\s$/)}"]
#     @error_hash[:errors][:whitespace_errors] << "Error at line #{line + 1}: #{@current_file.file_lines[line+1].scan_until(/\s$/)}" #adjust regex
#   end
#
#
#   if @current_file.file_lines[line].rest.match?(/\w+\s\s\w+/)
#
#     @error_hash[:errors][:whitespace_errors] << "Error at line #{line + 1}: #{@current_file.file_lines[line+1].scan_until(/\s$/)}".magenta #adjust regex
#   end
#
#
#   if @current_file.file_lines[line].rest.match?(/^\s*def/)
#
#
#     unless @current_file.file_lines[line+1].rest.match(/^\s{2}\w+/)
#         @error_hash[:line_nums]["Line #{line + 2}"] = 'line_indentation error: ' + "#{@current_file.file_lines[line+2].scan_until(/\s$/)}"
#
#       @error_hash[:errors][:line_indentation_errors] << "Error at line #{line + 2}:".red + "#{@current_file.file_lines[line+2].scan_until(/\s$/)}".yellow #adjust regex
#     end
#
#
#     if @current_file.file_lines[line+1].rest.include?("\n") && !@current_file.file_lines[line+1].rest.match?(/\w+/)
#
#       @error_hash[:errors][:empty_line_errors] << "Error at line #{line + 2}:".blue + "#{@current_file.file_lines[line+2].scan_until(/\s$/)}".yellow #adjust regex
#     end
#
#
#   end
#
#
#   if @current_file.file_lines[line].rest.match?(/^[#\s]*end$/)
#
#
#     if @current_file.file_lines[line-1].rest.include?("\n") && !@current_file.file_lines[line-1].rest.match?(/\w+/)
#
#       @error_hash[:errors][:empty_line_errors] << "Error at line #{line}: #{@current_file.file_lines[line].scan_until(/\s$/)}" #adjust regex
#     end
#
#
#     if @current_file.file_lines[line+1].rest.include?("\n") && @current_file.file_lines[line+1].rest.match?(/\w+/) && !@current_file.file_lines[line+1].rest.match?(/^[#\s]*end$/)
#
#       @error_hash[:errors][:empty_line_errors] << "Error at line #{line + 1}: #{@current_file.file_lines[line+1].scan_until(/\s$/)}" #adjust regex
#     end
#
#
#   end
#
#
# end

# def empty_line?(line)
#   if line.
# end

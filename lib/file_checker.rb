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

  @current_file.file_lines.length.times do |line|
    check_for_extra_lines(line)
    check_for_missing_lines(line)
    check_whitespaces(line)
    check_indentation(line)
    check_tags(line)
  end
end

def check_for_missing_lines(line)
  if @current_file.file_lines[line].rest.match?(/^[#\s]*end$/)
    if @current_file.file_lines[line + 1].rest.include?("\n") && @current_file.file_lines[line + 1].rest.match?(/\w+/) && !@current_file.file_lines[line + 1].rest.match?(/^[#\s]*end$/)
      puts "error at line #{line + 1}: missing empty line".red
    end
  end
end

def check_for_extra_lines(line)
  if @current_file.file_lines[line - 1].rest.include?("\n") && !@current_file.file_lines[line - 1].rest.match?(/\w+/)
    puts "error at line #{line}: extra line detected".white
  end
  if @current_file.file_lines[line].rest.include?("\n") && !@current_file.file_lines[line].rest.match?(/\w+/)
    if @current_file.file_lines[line - 1].rest.include?("\n") && !@current_file.file_lines[line - 1].rest.match?(/\w+/)
      puts "error at line #{line + 1}: extra line detected".cyan
    end
  end
  if @current_file.file_lines[line].rest.match?(/^\s*def/)
    if @current_file.file_lines[line + 1].rest.include?("\n") && !@current_file.file_lines[line + 1].rest.match?(/\w+/)
      puts "error at line #{line + 2}: extra line detected".blue
    end
  end
end

def check_indentation(line)
  if @current_file.file_lines[line].rest.match?(/^\s*def/)
    unless @current_file.file_lines[line + 1].rest.match(/^\s{2}\w+/)
      puts "error at line #{line + 2}: improper line indentation detected".green
    end
  end
end

def check_whitespaces(line)
  if @current_file.file_lines[line].rest[-2] == ' '
    puts "error at line #{line + 1}: trailing whitespace detected".magenta
  elsif @current_file.file_lines[line].rest.match?(/\w+\s\s\w+/)
    puts "error at line #{line + 1}: excess whitespace detected".yellow
  end
end

def check_tags(line); end

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

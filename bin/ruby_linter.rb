require './lib/file_checker'
require 'colorize'

puts 'Hello! This is a simple linter for Ruby'.bold
# sleep(1)
puts 'It will scan for whitespace errors, new line errors, indentation errors, and closing tag errors'.bold
# sleep(1)
puts 'Please enter the relative path of the file you would like to lint.'.bold
# sleep(1)
puts ''

filepath = './bad_code.rb'
# filepath = './good_code.rb'
# filepath = gets.chomp
check_for_errors(filepath)
# check_for_errors

# puts "#{@error_hash[:line_nums].keys[0]}: #{@error_hash[:line_nums].values[0]}" #[:errors]
# puts @error_hash[:line_nums]#["Line 3"].class

# if @error_hash.values.flatten.length == 0
#  puts " Congratulations! No errors were detected ".black.on_white
# else
#   puts " A total of #{@error_hash.values.flatten.length} total errors found on the following lines ".black.on_white
#   sleep(1)
#   puts "#{@error_hash[:whitespace_errors].length} whitespace errors found on the following lines".magenta#.bold
#   puts @error_hash[:whitespace_errors]
#   # sleep(@error_hash[:whitespace_errors].length)
#   puts "#{@error_hash[:empty_line_errors].length} empty line errors found on the following lines".magenta#.bold
#   puts @error_hash[:empty_line_errors]
#   # puts "#{@error_hash[:empty_line_errors]}".magenta
#   # sleep(@error_hash[:empty_line_errors].length)
#   puts "#{@error_hash[:indentation_errors].length} indentation errors found on the following lines".magenta#.bold
#   puts @error_hash[:indentation_errors]
#   # sleep(@error_hash[:indentation_errors].length)
#   puts "#{@error_hash[:closing_errors].length} closing errors found on the following lines".magenta#.bold
#   puts @error_hash[:closing_errors]
#   # sleep(@error_hash[:closing_errors].length)
#   puts "#{@error_hash[:tag_errors].length} tag errors found on the following lines".magenta#.bold
#   puts @error_hash[:tag_errors]
#
# end

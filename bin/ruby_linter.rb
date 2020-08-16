require './lib/file_checker'
require 'colorize'

@error_hash = {
  'Trailing Whitespace Detected' => [],
  'Excess Whitespace Detected' => [],
  'Extraneous Empty Line Detected' => [],
  'Indentation Error Detected' => [],
  'Missing Empty Line Detected' => [],
  'Missing Closing Statement Detected' => [],
  'Missing { Detected' => [],
  'Missing } Detected' => [],
  'Missing ( Detected' => [],
  'Missing ) Detected' => [],
  'Missing [ Detected' => [],
  'Missing ] Detected' => []
}

puts 'Hello! This is a simple linter for Ruby'.bold
sleep(1)
puts 'It will scan for whitespace errors, new line errors, indentation errors, and closing tag errors'.bold
sleep(1)
puts 'Please enter the relative path of the file you would like to lint.'.bold
sleep(1)
puts ''

filepath = './bad_code.rb'
# filepath = './good_code.rb'
# filepath = gets.chomp
open_linter(filepath)
puts ''
# p @error_hash[:whitespace_errors]
# p @error_hash.values.flatten.sort[0]
# p @error_hash.keys.select { |x| x == 3 }
# p @error_hash.values.flatten.length
# p @error_hash.values.flatten.sort.uniq
# p @error_hash.values.flatten.sort.min
# @error_hash.values.flatten.length.times do
#
# end

# p @error_hash.key(@error_hash.values.flatten.sort.min)

if @error_hash.values.flatten.length.zero?
  puts ' Congratulations! No errors were detected '.black.on_white
  puts ''
else
  puts " A total of #{@error_hash.values.flatten.uniq.length} total errors found on the following lines ".black.on_white
  puts ''
  sleep(1)

  @error_hash.values.flatten.uniq.length.times do |ind|
    puts ''
    puts "Line  #{@error_hash.values.flatten.sort.uniq[ind]} has the following alert(s):".bold.red
    @error_hash.each do |key, value|
      puts "  #{key}".magenta if value.any?(@error_hash.values.flatten.sort.uniq[ind])
    end
    sleep(1)
  end
end

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

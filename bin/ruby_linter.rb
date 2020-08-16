require './lib/file_checker'
require 'colorize'

puts 'Hello! This is a simple linter for Ruby'.bold
# sleep(1)
puts 'It will scan for whitespace errors, new line errors, indentation errors, and closing tag errors'.bold
# sleep(1)
puts 'Please enter the relative path of the file you would like to lint.'.bold
# sleep(1)
puts ''

open_linter(@filepath)
puts ''
@errors = @error_hash.values.flatten
if @errors.length.zero?
  puts ' Congratulations! No errors were detected '.black.on_white
  puts ''
else
  puts " A total of #{@errors.uniq.length} errors have been found on the following lines ".black.on_white
  puts ''
  # sleep(1)
  @errors.uniq.length.times do |ind|
    puts ''
    puts "Line  #{@errors.sort.uniq[ind]} has the following alert(s):".bold.red
    @error_hash.each do |key, value|
      puts "  #{key}".magenta if value.any?(@errors.sort.uniq[ind])
    end
    # sleep(1)
  end
end

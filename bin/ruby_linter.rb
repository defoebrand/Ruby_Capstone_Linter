require './lib/file_checker'
require 'colorize'

puts 'Hello! This is a simple linter for Ruby'.bold
sleep(0.5)
puts 'It will scan for whitespace errors, new line errors, indentation errors, and closing tag errors'.bold
sleep(0.5)
puts 'Please enter the relative path of the file you would like to lint.'.bold
sleep(0.5)

# @filepath = gets.chomp
open_linter(@filepath)
puts ''
@errors = @error_hash.values.flatten
if @errors.length.zero?
  puts ' Congratulations! No errors were detected '.bold.blue.on_green
else
  if @errors.length == 1
    puts " A total of #{@errors.uniq.length} error has been found on the following line ".bold.red.on_light_white
  else
    puts " A total of #{@errors.uniq.length} errors have been found on the following lines ".bold.red.on_light_white
  end
  sleep(0.5)
  @errors.uniq.length.times do |ind|
    puts ''
    print "  Line  #{@errors.sort.uniq[ind]} has the following alert(s):".bold.red
    @error_hash.each do |key, value|
      print "    - #{key}".magenta if value.any?(@errors.sort.uniq[ind])
    end
    sleep(0.5)
  end
  puts ''
end

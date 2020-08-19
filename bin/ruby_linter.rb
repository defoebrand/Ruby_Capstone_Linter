#!/usr/bin/env ruby

require 'colorize'
require_relative '../lib/file_checker'

puts 'Hello! This is a simple linter for Ruby'
sleep(0.375)
puts 'It will scan for whitespace errors, new line errors, indentation errors, and closing tag errors'
sleep(0.375)
puts 'Please enter the relative path of the file you would like to lint.'
sleep(0.375)

@filepath = gets.chomp
open_linter(@filepath)
puts ''
@errors = @error_hash.values.flatten
if @errors.length.zero?
  puts ' Congratulations! No errors were detected '
else
  if @errors.length == 1
    puts " A total of #{@errors.length} error has been found on the following line "
  else
    puts " A total of #{@errors.length} errors have been found on the following lines "
  end
  sleep(0.5)
  @errors.uniq.length.times do |ind|
    puts ''
    puts "  Line  #{@errors.sort.uniq[ind]} has the following alert(s):"
    @error_hash.each do |key, value|
      puts "    - #{key}" if value.any?(@errors.sort.uniq[ind])
    end
    sleep(0.25)
  end
  puts ''
end

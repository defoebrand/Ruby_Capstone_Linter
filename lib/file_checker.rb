require './lib/file_reader'

def open_linter(filepath = nil)
  @current_file = LintFile.new(filepath)
  @current_file.read_lines
  check_for_errors
end

def check_for_errors
  @current_file.file_lines.length.times do |line_num|
    check_whitespaces(line_num)
    check_for_extra_lines(line_num)
    check_for_missing_lines(line_num)
    check_indentation(line_num)
    check_tags(line_num)
    capture_block(line_num)
    check_capitalization(line_num)
  end
end

def check_whitespaces(line_num)
  if @current_file.file_lines[line_num].rest.match?(/\S/)
    if @current_file.file_lines[line_num].rest.match?(/\s{1,}\n/)
      @error_hash['Trailing Whitespace Detected'] << line_num + 1
    end
  end
  if @current_file.file_lines[line_num].rest.match?(/\w+\s{2,}\w+/)
    @error_hash['Excess Whitespace Detected'] << line_num + 1
  end
end

def check_for_extra_lines(line_num)
  if !@current_file.file_lines[line_num].rest.match?(/\S/) &&
     !@current_file.file_lines[line_num - 1].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/\bend\b/)
    @error_hash['Extraneous Empty Line Detected'] << line_num + 1
  end
end

def check_for_missing_lines(line_num)
  if @current_file.file_lines[line_num].rest.match?(/^[#\s]*end/)
    if @current_file.file_lines[line_num + 1].rest.match?(/\w+/) &&
       !@current_file.file_lines[line_num + 1].rest.match?(/^[#\s]*end$/)
      @error_hash['Missing Empty Line Detected'] << line_num + 1
    end
  end
end

def check_indentation(line_num = nil)
  if @current_file.file_lines[line_num].check_until(/^\s*end/i)
    @indent -= 2
    @close_block -= 1
    if @current_file.file_lines[line_num].scan_until(/^\s*/).split('').count != @indent
      @error_hash['Indentation Error Detected'] << line_num + 1
    end
  elsif @current_file.file_lines[line_num].check_until(/^\s*\w/)
    check_for_reserved_words(line_num)
  end
  if line_num + 1 == @current_file.file_lines.length
    @error_hash['Missing Final Closing Statement Detected'] << line_num + 1 if @indent != @open_block + @close_block
  end
end

def check_for_reserved_words(line_num)
  @reserved_words.length.times do
    if @reserved_words.any? do |regexp|
         @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
       end
      if @current_file.file_lines[line_num].scan_until(/^\s*/).length != @indent
        @error_hash['Indentation Error Detected'] << line_num + 1
      end
      @indent += 2
      @open_block += 1
      break
    elsif @current_file.file_lines[line_num].reset.scan_until(/^\s*/).length != @indent
      @error_hash['Indentation Error Detected'] << line_num + 1
      break
    end
  end
end

def check_tags(line_num)
  @tags_hash.each do |key, value|
    open = Regexp.new key
    close = Regexp.new value
    if @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(open)
      unless @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(close)
        @error_hash["Missing #{value.split('').last} Detected"] << line_num + 1
      end
    elsif @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(close)
      unless @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(open)
        @error_hash["Missing #{key.split('').last} Detected"] << line_num + 1
      end
    end
  end
end

def check_capitalization(line_num)
  if @current_file.file_lines[line_num].check_until(/^\s*\w/)
    if @reserved_words.any? do |regexp|
         @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
         @current_file.file_lines[line_num].scan_until(regexp)
       end
      if @current_file.file_lines[line_num].matched != @current_file.file_lines[line_num].matched.downcase
        @error_hash['Incorrect Capitalization of Reserved Word Detected'] << line_num + 1
      end
    end
  end
end

def capture_block(line_num)
  if @found_end == true
    @found_end = false
    @found_def = false
    @def_block = []
  elsif @reserved_words.any? do |regexp|
          @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
        end
    start_def_block(line_num)
  elsif @found_def == true
    end_def_block(line_num)
  end
end

def start_def_block(line_num)
  if @found_def == true
    @error_hash['Missing Closing Statement Detected'] << line_num
    @found_end = false
    @found_def = false
    @def_block = []
  elsif @current_file.file_lines[line_num].rest.match?(Regexp.new(@reserved_words[0]))
    # p 'yay'
    # p @current_file.file_lines[line_num].rest.match(Regexp.new(@reserved_words[0])).string
  elsif @current_file.file_lines[line_num].rest.match?(/def/)
    @found_def = true
    @def_block << @current_file.file_lines[line_num].rest
    capture_block(line_num + 1)
  end
end

def end_def_block(line_num)
  if @current_file.file_lines[line_num].rest.match?(/end/)
    @found_end = true
    @def_block << @current_file.file_lines[line_num].rest
    capture_block(line_num)
  else
    @def_block << @current_file.file_lines[line_num].rest
    capture_block(line_num + 1)
  end
end

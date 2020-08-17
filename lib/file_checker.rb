require './lib/file_reader'

@found_def = false
@found_end = false
@res_words = 0
@blocks = 0

def open_linter(filepath = nil)
  @current_file = LintFile.new(filepath)
  @current_file.read_lines
  check_for_errors
end

def check_for_errors
  @current_file.file_lines.length.times do |line_num|
    capture_block(line_num)
    check_whitespaces(line_num)
    check_for_extra_lines(line_num)
    check_for_missing_lines(line_num)
    check_indentation(line_num)
    check_tags(line_num)
    check_capitalization(line_num)
    if line_num + 1 == @current_file.file_lines.length
      @error_hash['Missing Final Closing Statement Detected'] << line_num + 1 if @res_words != 0
    end
  end
end

def check_whitespaces(line_num)
  if @current_file.file_lines[line_num].string.match?(/\S/)
    if @current_file.file_lines[line_num].string.match?(/\s{1,}\n/)
      @error_hash['Trailing Whitespace Detected'] << line_num + 1
    end
  end
  if @current_file.file_lines[line_num].string.match?(/\w+\s{2,}\w+/)
    @error_hash['Excess Whitespace Detected'] << line_num + 1
  end
end

def check_for_extra_lines(line_num)
  if !@current_file.file_lines[line_num].string.match?(/\S/) &&
     !@current_file.file_lines[line_num - 1].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/\bend\b/)
    @error_hash['Extraneous Empty Line Detected'] << line_num + 1
  end
end

def check_for_missing_lines(line_num)
  if @current_file.file_lines[line_num].string.match?(/^[#\s]*end/)
    if @current_file.file_lines[line_num + 1].string.match?(/\w+/) &&
       !@current_file.file_lines[line_num + 1].string.match?(/^[#\s]*end$/)
      @error_hash['Missing Empty Line Detected'] << line_num + 1
    end
  end
end

def check_indentation(line_num = nil)
  if @current_file.file_lines[line_num].check_until(/^\s*end/i)
    @indent -= 2
    if @current_file.file_lines[line_num].scan_until(/^\s*/).split('').count != @indent
      @error_hash['Indentation Error Detected'] << line_num + 1
    end
  elsif @current_file.file_lines[line_num].check_until(/^\s*\w/)
    check_for_reserved_words(line_num)
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
  if @found_end == true && @blocks.zero?
    @found_end = false
    @found_def = false
  elsif @reserved_words.any? do |regexp|
          @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
        end
    handle_res_words(line_num)
  elsif @found_def == true
    end_def_block(line_num)
  end
end

def handle_res_words(line_num)
  if @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.last)
    @res_words += 1
  elsif @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.first)
    start_def_block(line_num)
  else
    @res_words += 1
    @blocks += 1
  end
end

def start_def_block(line_num)
  if @found_def == true
    @error_hash['Missing Closing Statement Detected'] << line_num - 1
    if @error_hash['Extraneous Empty Line Detected'].include?(line_num - 1)
      test = @error_hash['Extraneous Empty Line Detected']
      test.delete_at(@error_hash['Extraneous Empty Line Detected'].index(line_num - 1)) &&
        test.delete_at(@error_hash['Extraneous Empty Line Detected'].index(line_num))
      @indent -= 2 if @blocks.zero?
    end
    @found_end = false
    @res_words -= 1
    @blocks -= 1
    @indent -= 2 if @blocks.zero?
  elsif @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.first)
    @found_def = true
    @blocks += 1
    @res_words += 1
  end
end

def end_def_block(line_num)
  if @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/end/)
    @found_end = true
    @blocks -= 1
    @res_words -= 1
    capture_block(line_num + 1) if @blocks.zero?
  end
end

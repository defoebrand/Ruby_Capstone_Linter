require_relative '../lib/file_reader'

def open_linter(filepath)
  @current_file = LintFile.new(filepath)
  @error_hash = { 'Trailing Whitespace Detected' => [], 'Excess Whitespace Detected' => [],
                  'Extraneous Empty Line Detected' => [], 'Missing Empty Line Detected' => [],
                  'Indentation Error Detected' => [], 'Missing Closing Statement Detected' => [],
                  'Missing Final Closing Statement Detected' => [],
                  'Incorrect Capitalization of Reserved Word Detected' => [],
                  'Missing { Detected' => [], 'Missing } Detected' => [], 'Missing ( Detected' => [],
                  'Missing ) Detected' => [], 'Missing [ Detected' => [], 'Missing ] Detected' => [] }
  @tags_hash = { '\{' => '\}', '\(' => '\)', '\[' => '\]' }
  @reserved_words = [/def/i, /if/i, /do/i, /class/i]
  @block_start = false
  @block_end = false
  @reserved_word_count = 0
  @nest_count = 0
  @indent = 0
  @current_file.read_lines
  check_for_errors
end

private

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
      @error_hash['Missing Final Closing Statement Detected'] << line_num + 1 if @reserved_word_count != 0
    end
  end
end

def capture_block(line_num)
  if @block_end == true && @nest_count <= 0
    @block_end = false
    @block_start = false
  elsif @reserved_words.any? do |regexp|
          @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
        end
    handle_reserved_word_count(line_num)
  elsif @block_start == true
    end_def_block(line_num)
  end
end

def end_def_block(line_num)
  return unless @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/end/)

  @block_end = true
  @nest_count -= 1
  @reserved_word_count -= 1
  capture_block(line_num + 1)
end

def handle_reserved_word_count(line_num)
  if @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.last)
    @reserved_word_count += 1
  elsif @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.first)
    start_def_block(line_num)
  else
    @reserved_word_count += 1
    @nest_count += 1
  end
end

def start_def_block(line_num)
  if @block_start == true
    @error_hash['Missing Closing Statement Detected'] << line_num - 1
    double_error(line_num)
  elsif @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(@reserved_words.first)
    @block_start = true
    @nest_count += 1
    @reserved_word_count += 1
  end
end

def double_error(line_num)
  if @error_hash['Extraneous Empty Line Detected'].include?(line_num - 1)
    eraser = @error_hash['Extraneous Empty Line Detected']
    eraser.delete_at(@error_hash['Extraneous Empty Line Detected'].index(line_num - 1)) &&
      eraser.delete_at(@error_hash['Extraneous Empty Line Detected'].index(line_num))
    @indent -= 2 if @nest_count.zero?
  end
  @block_end = false
  @nest_count -= 1
  @indent -= 2 if @nest_count.zero?
end

def check_whitespaces(line_num)
  unless @current_file.file_lines[line_num].string.match?(/\S/) &&
         !@current_file.file_lines[line_num].string.match?(/^\s*\#+/)
    return
  end

  if @current_file.file_lines[line_num].string.match?(/\s{1,}\n/)
    @error_hash['Trailing Whitespace Detected'] << line_num + 1
  elsif @current_file.file_lines[line_num].string.match?(/^\s*\w+\s{2,}\w+$/)
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
  return unless @current_file.file_lines[line_num].string.match?(/^[#\s]*end/)

  if @current_file.file_lines[line_num + 1].string.match?(/\w+/) &&
     !@current_file.file_lines[line_num + 1].string.match?(/^[#\s]*end$/)
    @error_hash['Missing Empty Line Detected'] << line_num + 1
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
  return unless @current_file.file_lines[line_num].check_until(/^\s*\w/)

  if @reserved_words.any? do |regexp|
       @current_file.file_lines[line_num].string.gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(regexp)
       @current_file.file_lines[line_num].scan_until(regexp)
     end
    if @current_file.file_lines[line_num].matched != @current_file.file_lines[line_num].matched.downcase
      @error_hash['Incorrect Capitalization of Reserved Word Detected'] << line_num + 1
    end

  end
end

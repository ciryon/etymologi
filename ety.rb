#!/usr/bin/ruby

# Etymologi
# Written by Christian Hedin
#
# If you want Markdown output
#require 'rubygems'
#require 'reverse_markdown'
# and edit in the script

class String
	def strip_tags
		self.gsub( %r{</?[^>]+?>}, '' )
	end
end


class Etymology

  def initialize
    @files_dir = "/Users/ciryon/Documents/Coding/Ruby/etymologi/Pages" # Change this to your data dir
    @text_files = read_files()
    @found_files = Hash.new
  end


  def read_files
    Dir.glob("#{@files_dir}/*.txt")
  end

  def number_of_open_files
    return @text_files.count
  end

  def query(query)
    results = `ag --vimgrep "<b>.*(#{query}).*<\/b>" #{@files_dir}/*.txt`
    return parse_output(results)
  end

  def print_query_results(results)
    results.each do |result|
      puts result
      puts ""
    end
  end

  def parse_output(output)
    results = []
    output.split("\n").each do |line|
      parts = line.split(":")
      page = parts[0]
      line = parts[1]
      result = handle_page(page,line)
      if result != nil
        formatted_result = result.strip_tags # or  ReverseMarkdown.convert result
        results << formatted_result
      end
    end
    return results
  end

  def handle_page(page,line)
    @text_files.each do |file|
      if file == page
        text = File.read(file)
        return handle_line_in_text text, line
      end
    end
    return nil
  end


  def handle_line_in_text(text,searched_line) 
    is_in_found_block = false
    counter = 1
    result = ""
    text.split("\n").each do |line|
      line = line.chomp()
      if counter == searched_line.to_i
        is_in_found_block = true
      end

      if line.length == 0
        is_in_found_block = false
      end

      if is_in_found_block
        result = result + line
      end
      
      counter = counter + 1

    end
    return result
  end

end


# Main
#
query = ARGV[0]
ety = Etymology.new
results = ety.query(query)
if results.count > 0
  ety.print_query_results(results)
else
  puts "Inga resultat för '#{query}'"
end

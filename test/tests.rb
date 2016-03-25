require 'rubygems'
require 'test/unit'

require File.expand_path("./ety.rb")


class EtymologyTest < Test::Unit::TestCase

def test_open_files
  ety = Etymology.new
  assert_equal(1372,ety.number_of_open_files(),"Incorrect number of files found")
end

def test_query_bok
  ety = Etymology.new
  assert_equal(4,ety.query("bok").count,"Incorrect query result.")
end

end

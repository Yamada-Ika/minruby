# frozen_string_literal: true

require 'minruby'
require './surumeruby'

# p ARGV
str = surumeruby_load()
p str
tree = surumeruby_parse(str)
pp tree

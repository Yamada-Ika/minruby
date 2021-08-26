# frozen_string_literal: true

# ruby parser
require 'ripper'

# input ruby script
def surumeruby_load()
  File.read(ARGV.shift)
end

# parse ruby script to tree
def surumeruby_parse(src)
  Ripper.sexp(src)
end
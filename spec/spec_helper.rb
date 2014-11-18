require "simplecov"
SimpleCov.start do
  add_filter '/spec/'
end

begin
  require 'coveralls'
  Coveralls.wear!
rescue LoadError
end

require "nb"

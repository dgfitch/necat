require 'board.rb'


Given /^a board with radius (\d+)$/ do |n|
  @board = Board.new n
end

Then /^the number of hexes should be (\d+)$/ do |n|
  @board.hexes.should_be n
end

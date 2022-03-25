require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end


  def score
    @attempt = params[:attempt]
    @letters_string = params[:letters]
    @letters_array = @letters_string.split
    @message = run_game(@attempt, @letters_array)
  end
end

private

def generate_grid(grid_size)
  grid = []
  grid_size.times do
    letter = ('A'..'Z').to_a.sample
    grid << letter
  end
  grid
end

def get_word_info(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  word_info_serialized = URI.open(url).read
  JSON.parse(word_info_serialized)
end

def run_game(attempt, grid)
  word_info = get_word_info(attempt)

  if grid_valid?(attempt, grid)
    if word_info['found']
      @message = "Congratulations! #{@attempt.upcase} is a valid English word!"
    else
      @message = "Sorry but #{@attempt.upcase} does not seem to be a valid English word."
    end
  else
    @message = "Sorry but #{@attempt.upcase} can't be built out of #{@letters_string}."
  end
  @message
end

def grid_valid?(attempt, grid)
  attempt.upcase.chars.each do |letter|
    if grid.include?(letter)
      grid.delete_at(grid.index(letter))
    else
      return false
    end
  end
  true
end

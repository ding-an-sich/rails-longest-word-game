require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    letters = params[:letters]
    word = params[:word]
    english = english?(word)
    in_grid = grid?(word, letters)
    session[:total_score] = session[:total_score].nil? ? 0 : session[:total_score]
    @score = english && in_grid ? word.length : 0
    session[:total_score] += @score
    @end_string = build_string_get_rid_of_icecream(english, in_grid, word, letters)
  end

  private

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    data = open(url).read
    wagon_json = JSON.parse(data)
    wagon_json["found"]
  end

  def grid?(word, letters)
    word_array = word.upcase.split("")
    word_array.all? do |char|
      letters.include? char
      word_array.count(char) <= letters.count(char)
    end
  end

  def build_string_get_rid_of_icecream(english, in_grid, word, letters)
    if english && in_grid
      "Congratulations! #{word.upcase} is a valid English word!"
    elsif english
      "Sorry, but #{word.upcase} can't be built out of #{letters}"
    else
      "Sorry, but #{word.upcase} does not seem to be a valid English word..."
    end
  end
end

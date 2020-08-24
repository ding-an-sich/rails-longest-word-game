# frozen_string_literal: true

# Word game controller
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
    session[:total_score] = init_total_score
    @score = english && in_grid ? word.length : 0
    session[:total_score] += @score
    @end_string = build_stringy_get_rid_of_icecreamy(english, in_grid, word, letters)
  end

  private

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    wagon_json = JSON.parse(URI.parse(url).read)
    wagon_json['found']
  end

  def grid?(word, letters)
    word_array = word.upcase.split('')
    word_array.all? do |char| # Check if every char in the word matches the two conditions
      letters.include? char
      word_array.count(char) <= letters.count(char)
    end
  end

  def build_stringy_get_rid_of_icecreamy(english, in_grid, word, letters)
    if english && in_grid
      "Congratulations! #{word.upcase} is a valid English word!"
    elsif english
      "Sorry, but #{word.upcase} can't be built out of #{letters}"
    else
      "Sorry, but #{word.upcase} does not seem to be a valid English word..."
    end
  end

  def init_total_score
    session[:total_score].nil? ? 0 : session[:total_score]
  end
end

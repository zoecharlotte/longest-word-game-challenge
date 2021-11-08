require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    if english_word?(@word) && included?(@word, @letters)
      @response = "Congratulations! #{@word} is a valid English word!"
    elsif english_word?(@word)
      @response = "Sorry but #{@word} can't be built out of #{@letters}"
    else
      @response = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  private

  def english_word?(word)
    user_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    user = JSON.parse(user_serialized.read)
    user['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end

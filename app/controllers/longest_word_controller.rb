require 'open-uri'

class LongestWordController < ApplicationController

  def grid
    grid_size = params[:grid_size].to_i
    grid = generate_grid(grid_size)
    @grid = grid.join

  end

  def game


  end


  def generate_grid(grid_size)
    @time_start = Time.now.to_i
    common_letters = %w(A A E E I O U T S L P R M N  )
    abc = ("A".."Z").to_a + common_letters
    grid = []
   (1..grid_size).each do
      grid << abc.sample
    end
    grid
  end

  def check_grid(attempt, grid)
    letters = attempt.chars
    check = []
    letters.each do |letter|
      letter = letter.upcase
      grid.include?(letter) ? check << true && grid.delete_at(grid.find_index(letter)) : check << false
    end
    if check.include?(false)
      false
    else
      true
    end
  end

  def check_api(attempt)
    api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    open(api_url) do |stream|
      translation = JSON.parse(stream.read)
      if translation["term0"].nil? || translation["term0"]["PrincipalTranslations"]["0"]["OriginalTerm"]["term"].nil?
        false
      else
        true
      end
    end
  end

def translate_word(word)
  api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{word}"
  open(api_url) do |stream|
    translation = JSON.parse(stream.read)
    translation["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
  end
end

def create_results(word, score, message, translation)
  @score = {
    word: word,
    translation: translation,
    score: score,
    message: message
  }
end

  def create_score(attempt, english, grid, time, griddr)
    if grid && english
      score = (((attempt.length) * 5) - griddr.length) + ( time / 20)

      create_results(attempt, score, "well done", translate_word(attempt))
    elsif !grid && english
      create_results(attempt, 0, "not in the grid", nil)
    else
      create_results(attempt, 0, "not an english word", nil)
    end
  end

  def score
    end_time = Time.now.to_i
    start_time = params[:time_start].to_i
    time = start_time - end_time
    attempt = params[:attempt]
    @attempt = attempt
    grid_from_form = params[:grid].chars
    @grid_from = grid_from_form
    english = check_api(attempt)
    grid = check_grid(attempt, grid_from_form)

    create_score(attempt, english, grid, time, grid_from_form)
  end




end

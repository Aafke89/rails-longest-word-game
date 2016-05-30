Rails.application.routes.draw do
  get 'game', to: 'longest_word#game'

  get 'score', to: 'longest_word#score'

  get 'grid', to: 'longest_word#grid'

  root 'longest_word#game'

end

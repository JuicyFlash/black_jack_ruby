# Player cards
# Player score
# Player bank

# Diler cards
# Diler score
# Diler bank

# Game message
# AvilableActions
require_relative 'game'

class GameInterface

  def initialize
    @game = Game.new()

  end

  def render_interface
    while @game.is_active
      refresh_interface

      user_input = gets.chop.to_i
      @game.available_actions[user_input][:action].call
    end
  end

  private

  def refresh_interface
    @game.game_statistic

    puts 'Доступные действия: ' if available_actions.length.positive?

    available_actions.each { |action| puts "#{available_actions.index(action)} #{action[:caption]}" }
  end

  def available_actions
    @game.available_actions
  end

end

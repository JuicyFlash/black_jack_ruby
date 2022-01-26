require_relative 'controller/game'

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
    game_statistic

    puts 'Доступные действия: ' if available_actions.length.positive?

    available_actions.each { |action| puts "#{available_actions.index(action)} #{action[:caption]}" }
  end

  def game_statistic
    puts '---------------------------------'
    puts "Сообщение игры: #{@game.game_message}"
    if @game.players_info.length.positive?
      @game.players_info.each do |player|
        next if player.nil?

        puts "----Игрок: #{player[:name]}" if player[:name].length.positive?
        puts "Карты: #{player[:cards]}" if player[:cards].length.positive?
        puts "Очки: #{player[:score]}" if player[:score].length.positive?
        puts "Банк: #{player[:bank]}" if player[:bank].positive?
      end
    end
    if @game.game_bank.positive?
      puts '-----------'
      puts "[ В банке игры: #{@game.game_bank} ]"
    end
    puts '-----------'
  end



  def available_actions
    @game.available_actions
  end

end

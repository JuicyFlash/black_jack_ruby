
require_relative 'model/deck'
require_relative 'model/player'
require_relative 'model/computer_player'

class Game

  attr_reader :is_active, :diller, :player, :game_bank

  def initialize
    @is_active = true
    @available_actions = []
    @game_bank = 0
    @game_message = 'необходимо зарегистрировать игрока'
    @game_status = :prepare
    @diller = ComputerPlayer.new('Дилер', 100)
    @actions =
      [{
        name: 'exit',
        caption: 'Выход',
        action: method(:exit)
      },
       {
         name: 'finish_game',
         caption: 'Завершить игру - открыть карты',
         action: method(:finish_game)
       },
       {
         name: 'take_card',
         caption: 'Взять карту',
         action: method(:player_take_card)
       },
       {
         name: 'finish_turn',
         caption: 'Завершить ход',
         action: method(:finish_turn)
       },
       {
         name: 'register_player',
         caption: 'Регистрация игрока',
         action: method(:register_player)
       },
       {
         name: 'start_game',
         caption: 'Начать игру',
         action: method(:start_game)
       }]

  end

  def game_message
    puts "Сообщение игры: #{@game_message}"
  end

  def game_statistic
    puts '---------------------------------'
    game_message
    if @game_status.eql?(:in_progress)
      player_info_anonymous (diller)
    else
      player_info(diller)
    end
    puts "[ В банке игры: #{game_bank} ]" if game_bank.positive?
    player_info(player)
    puts '-----------'
  end

  def available_actions
    @available_actions = []

    # Начало игры, доступно действие регистрации игрока
    if player.nil? && @game_status == :prepare
      @available_actions << @actions.select { |action| action[:name] == 'register_player' }[0]

    # Если игрок зарегистрирован или игра закончена добавляем действие начать игру (заново)
    elsif (!player.nil? && @game_status == :prepare) || @game_status == :finish
      @available_actions << @actions.select { |action| action[:name] == 'start_game' }[0]
    # Если игра в процессе
    elsif @game_status == :in_progress
      # Добавляем действие взять карту текущему игроку, если она ему нужна
      @available_actions << @actions.select { |action| action[:name] == 'take_card' }[0]
      # Действие завершить ход
      @available_actions << @actions.select { |action| action[:name] == 'finish_turn' }[0]
      # Днйствие завершить игру (открыть карты)
      @available_actions << @actions.select { |action| action[:name] == 'finish_game' }[0]
    end
    # Действие выход
    @available_actions << @actions.select { |action| action[:name] == 'exit' }[0]
    @available_actions
  end

  private
  # Сделать автоход
  def auto_turn
    player_take_card if players_turn == diller && players_turn.need_card?
    finish_game if player.cards.size == 3
    finish_turn
  end

  # Сравнить очки двух игроков
  def compare_scores(player1, player2)
    if player1.score > 21
      player2
    elsif player2.score > 21
      player1
    elsif player1.score > player2.score && player1.score <= 21
      player1
    elsif player2.score > player1.score && player2.score <= 21
      player2
    elsif
    nil
    end
  end

  # Сделать ставку игроку
  def player_make_bet(player, bet)
    player.bank -= bet
    @game_bank += bet
  end

  # Возаврашает игрока текущего хода
  def players_turn
    @players_turn ||= diller
  end

  # Обезличенная информация по игроку
  def player_info_anonymous(player)
    puts "Игрок: #{player.name}, банк: #{player.bank}"
    print 'Карты: '
    player.cards.length.times { print '[X]' }
    puts
    puts 'Очки ??'
  end

  # Информация по игроку
  def player_info(player)

    unless player.nil?
      puts "Игрок: #{player.name}, банк: #{player.bank}"

      if player.cards.length.positive?
        print 'Карты: '
        player.cards.each do |card|
          print card.name
        end
        puts
        puts "Очки: #{player.score}"
      end
    end

  end

  # =====================Методы @actions=====================
  # Начало игры
  def start_game
    @game_deck = Deck.new()
    Deck.generate_full_deck(@game_deck)
    @game_status = :in_progress
    @players_turn = player
    player_make_bet(player, 10)
    player_make_bet(diller, 10)
    @game_message = "игра начата, ходит игрок #{@players_turn.name}"
    player.drop_cards
    diller.drop_cards
    2.times{ @diller.take_card(@game_deck.give_card) }
    2.times { @player.take_card(@game_deck.give_card) }
  end

  # Регистрация игрока
  def register_player
    puts 'Введите имя игрока: '
    @player = Player.new(gets.chop.to_s, 100)
    if @player.valid?
      @game_message = "Игрок #{player.name} зарегистрирован"
    else
      puts 'Игрок не валиден'
      exit
    end
  end

  # Взять карту игроку
  def player_take_card
    players_turn.take_card(@game_deck.give_card)
    finish_game if players_turn.score > 21
    finish_turn
  end

  # Заверишть ход
  def finish_turn
    if players_turn == diller
      @players_turn = player
    else
      @players_turn = diller
      auto_turn
    end
  end

  # Заверишть игру
  def finish_game
    @game_status = :finish
    winner = compare_scores(player, diller)

    if !winner.nil?
      @game_message = "Игрок #{winner.name} победил, набрав #{winner.score} очков"
      winner.bank += game_bank
    else
      @game_message = 'Ничья'
      player.bank += game_bank / 2
      diller.bank += game_bank / 2
    end
    @game_bank = 0

  end
  # Выход
  def exit
    @is_active = false
  end

end
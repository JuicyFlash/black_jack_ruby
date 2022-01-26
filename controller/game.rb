
require_relative '../model/deck'
require_relative '../model/player'
require_relative '../model/computer_player'

class Game

  attr_reader :is_active, :game_bank, :game_message

  ACTIONS =
    [{
      name: :exit,
      caption: 'Выход'
    },
     {
       name: :finish_game,
       caption: 'Завершить игру - открыть карты'

     },
     {
       name: :player_take_card,
       caption: 'Взять карту'

     },
     {
       name: :finish_turn,
       caption: 'Завершить ход'

     },
     {
       name: :register_player,
       caption: 'Регистрация игрока'

     },
     {
       name: :start_game,
       caption: 'Начать игру'
     }].freeze

  def initialize

    @is_active = true
    @available_actions = []
    @game_bank = 0
    @game_message = 'необходимо зарегистрировать игрока'
    @game_status = :prepare
    @diller = ComputerPlayer.new('Дилер', 100)


  end

  def available_actions
    @available_actions = []

    # Начало игры, доступно действие регистрации игрока
    if player.nil? && @game_status == :prepare
      @available_actions <<  get_action(:register_player)

    # Если игрок зарегистрирован или игра закончена добавляем действие начать игру (заново)
    elsif (!player.nil? && @game_status == :prepare) || @game_status == :finish
      @available_actions << get_action(:start_game)

    # Если игра в процессе
    elsif @game_status == :in_progress
      # Добавляем действие взять карту текущему игроку, если она ему нужна
      @available_actions << get_action(:player_take_card)

      # Действие завершить ход
      @available_actions << get_action(:finish_turn)

      # Днйствие завершить игру (открыть карты)
      @available_actions << get_action(:finish_game)

    end
    # Действие выход
    @available_actions << get_action(:exit)

    @available_actions
  end

  def players_info
    players ||= []
    players << player_info(diller)
    players << player_info(player)
    players
  end

  private

  attr_reader :player, :diller

  # Получаем событие
  def get_action(action_name)
    { caption: ACTIONS.select { |action| action[:name] == action_name }[0][:caption],
      action: method(ACTIONS.select { |action| action[:name] == action_name }[0][:name]) }
  end

  # Информация по игроку
  def player_info(player)
    unless player.nil?
      { name: player.name,
        score: player_score(player),
        bank: player.bank,
        cards: player_cards(player) }
    end
  end

  def player_score(player)
    if (player == @diller) && @game_status != :finish
      '??'
    else
      player.score.to_s
    end
  end

  def player_cards(player)
    cards = ''
    if player.cards.length.positive?
      player.cards.each do |card|
        cards += if (player == @diller) && @game_status != :finish
                   '[X]'
                 else
                   card.name
                 end
      end
    end
    cards
  end

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

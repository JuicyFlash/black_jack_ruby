require_relative 'deck'
require_relative '../utils/validation'

class Player
  include Validation
  attr_accessor :name, :bank, :deck

  validate :name, :presence
  validate :bank, :presence
  validate :bank, :type, Integer
  validate :deck, :type, Deck

  def initialize(name, bank)
    self.name = name
    self.bank = bank
    self.deck = Deck.new()
  end

  def need_card?
    deck.cards.length < 3
  end

  def score
    result = 0
    a_value_count = 0
    deck.cards.each do |card|
      result += card.value
      a_value_count += 1 if (card.alternative_value - card.value).positive?
    end
    while a_value_count.positive?
      result += 9 * a_value_count if result + 9 * a_value_count <= 21
      a_value_count -= 1
    end
    result
  end

  def cards
    deck.cards
  end

  def take_deck(deck)
    self.deck = deck
  end

  def take_card(card)
    deck.put_cards(card) if need_card?
  end

  def drop_cards
    deck.reset
  end

end

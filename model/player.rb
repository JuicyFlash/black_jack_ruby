require_relative 'deck'

class Player

  attr_accessor :name, :bank, :deck, :controlled_by
  attr_reader :score

  def initialize(name, bank, deck)
    self.name = name
    self.bank = bank
    self.deck = deck
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

  def take_card(card)
    deck.put_cards(card) if need_card?
  end

  def drop_cards
    deck.reset
  end

end
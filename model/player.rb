require_relative 'deck'

class Player

  attr_accessor :name, :bank, :deck

  def initialize(name, bank, deck)
    self.name = name
    self.bank = bank
    self.deck = deck
  end

  def take_cards(*cards)
    deck.put_cards(cards)
  end

  def drop_cards
    deck.reset
  end

end
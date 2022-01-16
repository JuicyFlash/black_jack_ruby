
require_relative 'card'
require_relative 'club_card'
require_relative 'heart_card'
require_relative 'spade_card'
require_relative 'dimond_card'

class Deck

  def cards
    @cards ||= []
  end

  def give_card
    if cards.length.positive?
      card = cards[rand(cards.length)]
      cards.delete(card)
      card
    else
      nil
    end
  end

  def put_cards(*cards)
    cards.each { |card| @cards << card } if cards.length.positive?
  end

  def reset
    @cards = []
  end

  def generate_full_deck
    reset
    i = 1
    13.times do
     put_cards(ClubCard.new(i), HeartCard.new(i), DimondCard.new(i), SpadeCard.new(i))
     i += 1
   end
  end

end
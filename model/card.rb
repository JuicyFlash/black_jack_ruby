
class Card

  attr_accessor :card_suit, :card_idx

  def initialize(idx, card_suit)
    self.card_idx = idx
    self.card_suit = card_suit
  end

  def card_value
    if card_idx > 10
      10
    else
      card_idx
    end
  end


  def card_alternative_value
    if card_idx > 10 || card_idx == 1
      10
    else
      card_idx
    end
  end

  def card_name
    case
    when  card_idx == 1
      "[A#{suits_for_print[card_suit]}]"
    when  card_idx == 11
      "[J#{suits_for_print[card_suit]}]"
    when  card_idx == 12
      "[Q#{suits_for_print[card_suit]}]"
    when  card_idx == 13
      "[K#{suits_for_print[card_suit]}]"
    else
      "[#{card_value}#{suits_for_print[card_suit]}]"
    end
  end

  protected

  def suits_for_print
    { heart: "\u2665",
      dimond: "\u2666",
      club: "\u2663",
      spade: "\u2660" }

  end
end
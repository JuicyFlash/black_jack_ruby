require_relative 'player'

class HumanPlayer < Player

  def initialize(name, bank, deck)
    super
    controlled_by = :human
  end

  def need_card?
    super
  end

end

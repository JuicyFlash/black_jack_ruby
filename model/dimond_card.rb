require_relative 'card'

class DimondCard < Card

  def initialize(idx)
    super(idx, :dimond)
  end
end

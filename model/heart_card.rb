require_relative 'card'

class HeartCard < Card

  def initialize(idx)
    super(idx, :heart)
  end
end

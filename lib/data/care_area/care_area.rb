class CareArea
  attr_accessor :name
  attr_accessor :rooms

  def initialize(name = '', rooms = [])
    @name = name
    @rooms = rooms
  end

end
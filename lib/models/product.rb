class Product
  @@products = []

  attr_accessor :name

  def initialize(name:, price:)
    @name = name.capitalize
    @price = price
  end

  def save
    @@products << self
  end

  def format_price
    "R$ #{@price}"
  end

  def self.all
    @@products
  end
end
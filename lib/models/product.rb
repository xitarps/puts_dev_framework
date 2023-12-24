require_relative '../queries/products_query'
require_relative './model_base'

class Product < ModelBase
  attr_accessor :name

  def self.query_class = ( ProductsQuery )

  def initialize(**args)
    super
    @name = args[:name]&.capitalize
    @price = args[:price]
  end

  def format_price
    "R$ #{@price}"
  end
end
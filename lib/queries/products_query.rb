require_relative 'base_query'

class ProductsQuery < BaseQuery
  def self.model_class = ( Product )
end

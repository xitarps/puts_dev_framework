class ProductsController < ApplicationController
  def index
    {
      status: 200,
      view: Views::Products::Index.new(
        products: [],
        message: params&.dig(:algo)
      )
    }
  end

  def new
    {
      status: 200,
      view: Views::Products::New.new(
        message: params&.dig(:algo)
      )
    }
  end

  def create
    @product = Product.new(**product_params)
    @product.save

    {
      status: 200,
      view: Views::Products::Index.new(
        products: Product.all
      )
    }
  end

  private

  def product_params
    { name: params[:name], price: params[:price] }
  end
end

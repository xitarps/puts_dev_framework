class Views
  class Products
    class Index < EmbedRuby
      def render
        <<-HTML_RB
          <h1>
            Todos os Produtos
          </h1>

          <p>
            #{@message}
          </p>

          #{
            @products.map do |product|
              "
              <p>
                name: #{product.name}
                <br>
                price: #{product.format_price}
              </p>
              "
            end.join
          }
        HTML_RB
      end
    end
  end
end
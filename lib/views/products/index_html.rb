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

          <p>
            <a href="#{Routes.list[:products][:new][:get][:path]}" class="btn btn-success">
              Novo Produto
            </a>
          </p>

          #{
            @products.map do |product|
              "
              <p>
                name: #{product.name}
                <br>
                price: #{product.format_price}
                <br>
                <button type='button' class='btn btn-danger' onclick='deleteProduct(#{product.id})'>
                  Apagar
                </button>
              </p>
              "
            end.join
          }

          <script>
            function deleteProduct(id) {
              fetch('#{Routes.list[:products][:delete][:delete][:path].gsub(':id','')}' + id, {
                method: 'DELETE'
              })
              .then((response) => {
                window.location.replace('#{Routes.list[:products][:index][:get][:path]}');
              })
            }
          </script>

        HTML_RB
      end
    end
  end
end
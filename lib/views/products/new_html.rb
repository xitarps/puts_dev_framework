class Views
  class Products
    class New < EmbedRuby
      def render
        <<-HTML_RB

          <h1>
            Novo produto
          </h1>

          <p>
            <a href="#{Routes.list[:products][:index][:get][:path]}">
              Voltar
            </a>
          </p>

          <form action="#{Routes.list[:products][:create][:post][:path]}" method="POST">
            <label for="name">Name:</label>
            <br>
            <input type="text" id="name" name="name">
            <br>

            <label for="price">Price:</label>
            <br>
            <input type="number" id="price" name="price" step="0.01">
            <br>

            <br>

            <input class="btn btn-primary" type="submit" value="Salvar">
          </form>

        HTML_RB
      end
    end
  end
end
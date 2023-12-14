class Views
  class Products
    class New < EmbedRuby
      def render
        <<-HTML_RB

          <h1>
            Novo produto
          </h1>

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

            <input type="submit" value="Salvar">
          </form>

        HTML_RB
      end
    end
  end
end
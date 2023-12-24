class CreateProductsTable
  def self.migrate

    sql = <<~SQL
      CREATE TABLE products (
        id SERIAL PRIMARY KEY,
        name varchar(255) NOT NULL,
        price decimal NOT NULL,
        created_at date NOT NULL,
        updated_at date NOT NULL
      )
    SQL


    connection = Database.connection
    connection.exec(sql)
    connection&.close
  end
end

CreateProductsTable.migrate

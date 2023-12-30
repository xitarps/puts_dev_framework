class BaseQuery
  def self.table_name
    self.to_s.chomp('Query').to_underscore
  end

  def self.table_attributes
    model_class.new.table_attributes
  end

  def self.open_connection
    @connection = Database.connection
  end

  def self.close_connection
    @connection&.close
  end

  def self.date
    DateTime.now.to_s
  end

  def self.all
    begin
      open_connection

      lines = @connection.exec("SELECT * FROM #{table_name}")

      dynamic_attributes = table_attributes

      lines = lines.map do |line|
        dynamic_attributes.inject(
          {
            id: line['id'],
            created_at: line['created_at'],
            updated_at: line['updated_at'],
          }
        ) do |base_hash, attribute|
          base_hash.merge({ "#{attribute}": line[attribute] })
        end
      end

      lines.map { |hash_param| fix_encode(hash_param) }

    rescue PG::Error => e
      raise "#{e.message}"
    ensure
      close_connection
    end
  end

  def self.create(hash)
    begin
      hash = fix_encode(hash)

      sql = "
        INSERT INTO #{table_name}(#{hash.keys.join(', ')}, created_at, updated_at)
        VALUES(#{hash.values.map{ |value| "'#{value}'"}.join(', ')},
        '#{date}', '#{date}');
      "
      open_connection

      @connection.exec(sql)

    rescue PG::Error => e
      raise "#{e.message}"
    ensure
      close_connection
    end

    model_class.new(**hash)
  end

  def self.update(id, hash)
    begin

      hash = fix_encode(hash)

      sql = "
        UPDATE #{table_name} SET #{hash.map{ |key, value| "#{key} = '#{value}'"}.join(', ')}, updated_at = '#{date}'
        WHERE id = #{id.to_i}\;
        "

      open_connection
      @connection.exec(sql)

      model_class.new(**hash)
    rescue PG::Error => e
      raise "#{e.message}"
    ensure
      close_connection
    end
  end

  def self.find(id)
    begin
      open_connection
      sql = "SELECT * FROM #{table_name} WHERE id = #{id} LIMIT 1;"

      result = @connection.exec(sql).first

      hash = table_attributes.inject(
          {
            id: result['id'],
            created_at: result['created_at'],
            updated_at: result['updated_at'],
          }
        ) do |base_hash, attribute|
          base_hash.merge({ "#{attribute}": result[attribute] })
        end

        hash = fix_encode(hash)
    rescue PG::Error => e
      raise "#{e.message}"
    ensure
      close_connection
    end
  end

  def self.delete(id)
    begin
      open_connection

      sql = "DELETE FROM #{table_name} WHERE id = #{id}"

      @connection.exec(sql)

    rescue PG::Error => e
      raise "#{e.message}"
    ensure
      close_connection
    end
  end

  def self.fix_encode(hash)
    hash.transform_values{ |value| CGI::unescape(URI.decode_uri_component(value)) }
  end
end

class ModelBase
  attr_accessor :attributes, :id, :created_at, :updated_at

  def initialize(**hash)
    @attributes = hash.transform_keys(&:to_sym)
    @id = hash[:id]
    @created_at = hash[:created_at]
    @updated_at = hash[:updated_at]
  end

  def table_attributes
    self.instance_variables.map{ |var| var.to_s.delete('@') } - ['attributes']
  end

  def self.all
    self.query_class.all.map { |hash| self.new(**hash) }
  end

  def self.create(**attributes)
    self.query_class.create(**attributes)
  end

  def self.find(id)
    self.new(**self.query_class.find(id))
  end

  def self.delete(id)
    self.query_class.delete(id)
  end
end

class EmbedRuby
  def initialize(**args)
    args.each { |key, value| instance_variable_set("@#{key}", value) }
  end
end
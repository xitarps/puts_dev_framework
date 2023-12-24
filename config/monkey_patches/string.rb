class String
  def camelize
    split('_').collect(&:capitalize).join
  end

  def to_underscore
    gsub(/(.)([A-Z])/,'\1_\2').downcase
  end
end

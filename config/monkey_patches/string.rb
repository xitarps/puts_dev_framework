class String
  def camelize
    split('_').collect(&:capitalize).join
  end
end

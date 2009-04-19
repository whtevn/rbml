class String
  def blank?
    strip.empty?
  end
  
  def to_m
    self.split("::").inject(Rbml) { |injection, element| injection.const_get(element) }
  end
  
  #TODO: not really camelize
  def camelize
    self[0,1].upcase + self[1, self.length]
  end

  def as_partial
    arr = self.split("/")
    arr.last[0,0] = "_"
    arr.join("/")
  end
end

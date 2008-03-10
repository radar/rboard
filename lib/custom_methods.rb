class Time
  def ordinalize
    self.strftime("%d").to_i.ordinalize + " " + self.strftime("%B %Y %I:%M:%S%P")
  end
end
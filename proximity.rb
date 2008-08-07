class Date
  def to_words
    if self == Date.today
      "Today"
    elsif self == Date.today - 1
      "Yesterday"
    elsif self == Date.today + 1
      "Tomorrow"
    elsif ((Date.today - 7)..(Date.today - 1)).include?(self)
      "Last #{self.strftime("%A")}"
    elsif ((Date.today + 1)..(Date.today + 7)).include?(self)
      "Next #{self.strftime("%A")}"
    elsif ((Date.today + 8)..(Date.today + 14)).include?(self)
      "Two #{self.strftime("%A")}s away"
    elsif ((Date.today - 14)..(Date.today - 8)).include?(self)
      "Two #{self.strftime("%A")}s ago"
    elsif ((Date.today + 15)..(Date.today + 21)).include?(self)
      "Three #{self.strftime("%A")}s away"
    elsif ((Date.today - 21)..(Date.today - 15)).include?(self)
      "Three #{self.strftime("%A")}s ago"
    elsif ((Date.today + 22)..(Date.today + 29)).include?(self)
      "Four #{self.strftime("%A")}s away"
    elsif ((Date.today - 29)..(Date.today - 22)).include?(self)
      "Four #{self.strftime("%A")}s ago"
    elsif Date.today - 30 < self
      "More than a month ago"
    elsif Date.today + 30 > self
      "More than a month in the future"
    end
  end
end
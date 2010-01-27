class Array
  def all_previous(element, included=false)
    (included ? self[0..index(element)] : self[0..(index(element)-1)]) if !empty? && include?(element) && !index(element).zero? 
  end
  # For finding the element before another in an array.
  def previous(element)
    self[index(element)-1] if !empty? && include?(element) && !index(element).zero?
  end

  # For finding the element after another in an array.
  def next(element)
    self[index(element)+1] if !empty? && include?(element) && last != element
  end

  def all_next(element, included=false)
    (included ? self[index(element)..-1] : self[(index(element)+1)..-1]) if !empty? && include?(element) && last != element
  end
end



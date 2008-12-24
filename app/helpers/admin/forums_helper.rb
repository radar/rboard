module Admin::ForumsHelper
  def select_display(forum, attribute='title')
    output = ""
    forum.ancestors.size.times { output += "--" }
    output += forum.send(attribute)
  end
end
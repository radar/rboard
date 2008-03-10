module Admin::ForumsHelper
  def select_display(forum)
    output = ""
    forum.ancestors.size.times { output += "--" }
    output += forum.title
  end
end
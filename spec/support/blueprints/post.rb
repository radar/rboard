Post.blueprint do
  text { "This is some default text" }
  ip { Ip.make(:localhost) }
end
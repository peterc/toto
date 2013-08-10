class Debugging < Middleware
  def any(event)
    p event
    event
  end
end
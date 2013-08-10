class MirrorKeyboard < Middleware
  def mirror(note)
    (note - 60) * -1 + 60
  end

  def note_on(event)
    event[:message].note = mirror(event[:message].note)
    event
  end

  def note_off(event)
    event[:message].note = mirror(event[:message].note)
    event
  end
end
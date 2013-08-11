class Astleyator < Middleware
  NOTES = [67, 69, 70, 70, 72, 69, 67, 65, 67, 67, 69, 70, 67, 65, 77, 77, 72, 77, 72, 77,
           72, 67, 67, 69, 70, 67, 70, 67, 70, 72, 69, 67, 65, 67, 67, 69, 70, 67, 65, 72,
           72, 72, 74, 72, 70, 72, 74, 70, 72, 72, 72, 74, 72, 65, 67, 69, 70, 67, 72, 74,
           72, 65, 67, 70, 67, 74, 74, 72, 65, 67, 70, 67, 72, 72, 70, 69, 67, 65, 67, 70,
           67, 70, 72, 69, 67, 65, 65, 72, 70, 65, 67, 70, 67, 74, 74, 72, 65, 67, 70, 67,
           77, 69, 70, 69, 67, 65, 67, 70, 67, 70, 72, 69, 67, 65, 65, 72, 70]

  def init
    @astleymerator = Enumerator.new do |e|
      loop { NOTES.each {|n| e << n } }
    end
  end

  def note_on(event)
    # Will too many notes be lost here due to spurious events?
    event[:message].note = @astleymerator.next
    event
  end
end
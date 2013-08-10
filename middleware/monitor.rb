class Monitor < Middleware
  def note_on(event)
    synth.puts event[:message]
  end

  def note_off(event)
    synth.puts event[:message]
  end
end
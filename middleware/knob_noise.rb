class KnobNoise < Middleware
  def control_change(event, knob, value)
    synth.play_note(60 + (knob / 10) * 2, 20 + value / 6,0.1)
    event
  end
end
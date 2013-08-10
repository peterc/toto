class Arpeggiator < Middleware
  def init
    @speed = 0.2
    @arps = {}
    @pattern = [0, 4, 7]
    @pattern = [0, 7, 4]
  end

  def note_on(event)
    original_note = event[:message].dup
    synth.puts original_note

    if original_note.velocity == 0
      @arps[original_note.note][:timer].cancel
      return nil
    end

    @arps[original_note.note] = { :note => original_note.note, :position => 1 }

    @arps[original_note.note][:timer] = EventMachine::PeriodicTimer.new(@speed) do
      synth.play_note @arps[original_note.note][:note], 0
      @arps[original_note.note][:note] = original_note.note + @pattern[@arps[original_note.note][:position]]
      @arps[original_note.note][:position] += 1
      @arps[original_note.note][:position] = @arps[original_note.note][:position] % @pattern.length
      synth.play_note @arps[original_note.note][:note], original_note.velocity
    end

    nil
  end

  def note_off(event)
    @arps[event[:message].note][:timer].cancel
  end

  def control_change(event, knob, value)
    return unless knob == 28

    @speed = 0.1 + value / 256.0

    event
  end
end
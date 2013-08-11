class Arpeggiator < Middleware
  def init
    @speed = 0.6
    @live_notes = []
    @pos = 0
  end

  def note_on(event)
    note = event[:message].dup

    if note.velocity == 0
      @live_notes.delete(note.note)
      if @live_notes.empty?    
        synth.play_note @current_note, 0 if @current_note
        @arp.cancel
        @arp = nil
        @pos = 0
      end
      return nil
    end

    @live_notes << note.note
    @live_notes.uniq!

    @arp = EventMachine::PeriodicTimer.new(0) do
      synth.play_note @current_note, 0 if @current_note
      @current_note = @live_notes[@pos]
      begin
        @pos += 1
        @pos %= @live_notes.length 
        synth.play_note @current_note, note.velocity, 999 if @current_note
      rescue
        @pos = 0
      end

      wobble = 10.0
      @arp.interval = @speed / @live_notes.size #+ ((rand / wobble) - (1 / (wobble * 2)))
    end unless @arp

    nil
  end

  def note_off(event)
    @live_notes.delete(event[:message].note)
    if @live_notes.empty?    
      @arp.cancel 
      @arp = nil
      @pos = 0
    end
  end

  def control_change(event, knob, value)
    return event unless knob == 28

    @speed = 0.1 + value / 128.0

    if @arp
      @arp.interval = @speed / @live_notes.size
    end

    event
  end
end
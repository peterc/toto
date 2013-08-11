class Bender < Middleware
  def init
    @speed = 0.004
    @direction = 1
    @strength = 3
    @position = 64
    @degree = 50
  end

  def note_on(event)
    if event[:message].velocity == 0
      synth.puts MIDIMessage::PitchBend.new(0, 0, 64)
      @preload.cancel if @preload
      @preload = nil
      @timer.cancel if @timer
      @timer = nil
      synth.puts MIDIMessage::PitchBend.new(0, 0, 64)
      return event
    end

    @preload = EventMachine::Timer.new(0.5) do
      @timer = EventMachine::PeriodicTimer.new(@speed) do
        print "."
        @position += @direction
        @direction = (-1 * @strength) if @position > 64 + @degree
        @direction = (1 * @strength) if @position < 64 - @degree
        synth.puts MIDIMessage::PitchBend.new(0, 40, @position)
      end unless @timer
    end unless @timer

    event
  end

  #def control_change(event, knob, value)
  #  return event unless knob == 28
#
  #  @speed = 0.1 + value / 256.0
#
  #  if @timer
  #    @timer.interval = @speed
  #  end
#
  #  event
  #end
end
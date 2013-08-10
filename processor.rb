class Processor
  attr_reader :synth
  attr_accessor :middleware

  def initialize(synth)
    @synth = synth
    @middleware = []
  end

  def add_middleware(middleware)
    mw = middleware.new
    mw.init(synth)
    @middleware << mw 
  end

  def start
    @listener = MIDIEye::Listener.new(synth.input)

    @listener.listen_for() do |event|
      case event[:message]
      when MIDIMessage::NoteOn
        @middleware.inject(event) { |event, mw| mw.note_on(event) }
      when MIDIMessage::NoteOff
        @middleware.inject(event) { |event, mw| mw.note_off(event) }
      when MIDIMessage::ControlChange
        @middleware.inject(event) { |event, mw| mw.control_change(event, event[:message].index, event[:message].value) }
      end
      
      @middleware.inject(event) { |event, mw| mw.any(event) }
    end

    @listener.run(:background => true)

    EM.run { synth.play_intro }
  end
end
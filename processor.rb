class Processor
  attr_reader :synth
  attr_accessor :middleware

  def initialize(synth)
    @synth = synth
    @middleware = []
  end

  def add_middleware(middleware)
    mw = middleware.is_a?(Class) ? middleware.new : middleware
    mw.synth = synth

    @middleware << mw 
  end

  def active_middlewares
    @middleware.select { |mw| mw.active? }
  end

  def start
    @listener = MIDIEye::Listener.new(synth.input)

    @listener.listen_for() do |event|
      case event[:message]
      when MIDIMessage::NoteOn
        active_middlewares.inject(event) { |event, mw| mw.note_on(event) }
      when MIDIMessage::NoteOff
        active_middlewares.inject(event) { |event, mw| mw.note_off(event) }
      when MIDIMessage::ControlChange
        active_middlewares.inject(event) { |event, mw| mw.control_change(event, event[:message].index, event[:message].value) }
      when MIDIMessage::PitchBend
        synth.puts event[:message]
      end
      
      active_middlewares.inject(event) { |event, mw| mw.any(event) }
    end

    @listener.run(:background => true)

    EM.run { synth.play_intro }
  end
end
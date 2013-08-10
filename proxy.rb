require 'unimidi'
require 'midi-eye'
require 'eventmachine' 

class MIDISources
  def self.input
    @input ||= UniMIDI::Input.open(1)
  end

  def self.output
    @output ||= UniMIDI::Output.open(0)
  end
end

class Synth
  attr_reader :input, :output

  def initialize(input, output)
    @input = input
    @output = output
  end

  def play_note(note = 60, velocity = 127, off = 0.2)
    puts 144, note, velocity
    EM.add_timer(off) do
      puts 144, note, 0
    end
  end

  def play_note_in(note = 60, velocity = 127, time)
    EM.add_timer(time) do
      play_note(note, velocity)
    end
  end

  def puts(*args)
    @output.puts *args
  end

  def play_notes(*notes)
    notes.each do |note|
      play_note_in *note
    end
  end

  def play_intro
    play_notes [60, 40, 0.100]
  end
end

class Processor
  attr_reader :synth
  attr_accessor :middleware

  def initialize(synth)
    @synth = synth
    @events = { :any => [], :note_on => [], :note_off => [], :control_change => [] }
    @middleware = []
  end

  def add_middleware(middleware)
    mw = middleware.new
    mw.init(synth)
    @middleware << mw 
  end

  def on(*events, &blk)
    if events.empty?
      @events[:any] ||= []
      @events[:any] << blk
    end

    events.each do |name|
      @events[name] ||= []
      @events[name] << blk
    end
  end

  def start
    @listener = MIDIEye::Listener.new(synth.input)

    @listener.listen_for() do |event|
      case event[:message]
      when MIDIMessage::NoteOn
        @events[:note_on].each { |b| b.call(event) }
        @middleware.inject(event) { |event, mw| mw.note_on(event) }
      when MIDIMessage::NoteOff
        @events[:note_off].each { |b| b.call(event) }
        @middleware.inject(event) { |event, mw| mw.note_off(event) }
      when MIDIMessage::ControlChange
        @events[:control_change].each { |b| b.call(event, event[:message].index, event[:message].value) }
        @middleware.inject(event) { |event, mw| mw.control_change(event, event[:message].index, event[:message].value) }
      end



      @events[:any].each { |b| b.call(event) }
      
      @middleware.inject(event) { |event, mw| mw.any(event) }
    end

    @listener.run(:background => true)
  end
end

class Middleware
  attr_reader :synth

  def init(synth = nil, active = true)
    @synth = synth
    @active = true
  end

  def disable; @active = false; end
  def enable; @active = true; end

  def any(event); event; end
  def note_on(event); event; end
  def note_off(event); event; end
  def control_change(event, knob, value); event; end
end

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

class Monitor < Middleware
  def note_on(event)
    synth.puts event[:message]
  end

  def note_off(event)
    synth.puts event[:message]
  end
end

class Debugging < Middleware
  def any(event)
    p event
    event
  end
end

class KnobNoise < Middleware
  def control_change(event, knob, value)
    synth.play_note(60 + (knob / 10) * 2, 20 + value / 6,0.1)
    event
  end
end


synth = Synth.new(MIDISources.input, MIDISources.output)
processor = Processor.new(synth)

processor.add_middleware Debugging
processor.add_middleware KnobNoise
processor.add_middleware MirrorKeyboard
processor.add_middleware Monitor

processor.start

EM.run do
  synth.play_intro
end
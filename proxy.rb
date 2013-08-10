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

  def initialize(synth)
    @synth = synth
  end

  def start
    @listener = MIDIEye::Listener.new(synth.input)
    @listener.listen_for(:class => [MIDIMessage::NoteOn, MIDIMessage::NoteOff]) do |event|
      p event[:message].verbose_name
      event[:message].note = (event[:message].note - 60) * -1 + 60
      synth.puts event[:message]
    end

    @listener.run(:background => true)
  end
end

synth = Synth.new(MIDISources.input, MIDISources.output)

processor = Processor.new(synth)
processor.start

EM.run do
  synth.play_intro
end
require 'unimidi'
require 'midi-eye'
require 'eventmachine'
require 'midilib'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'

require_relative 'synth'
require_relative 'processor'
require_relative 'middleware'

synth = Synth.new(UniMIDI::Input.open(1), UniMIDI::Output.open(0))
processor = Processor.new(synth)


processor.add_middleware Debugging
#processor.add_middleware KnobNoise
#processor.add_middleware MirrorKeyboard
#processor.add_middleware ReverseEcho
processor.add_middleware Bender
#processor.add_middleware Arpeggiator
processor.add_middleware Monitor

processor.add_middleware KnobControl.new(
  21 => Debugging,
  22 => KnobNoise,
  23 => MirrorKeyboard,
  24 => Monitor,
  25 => Arpeggiator
)

#processor.start


# Create a new, empty sequence.
seq = MIDI::Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open('./sandbox/rickroll.mid', 'rb') do |file|
  seq.read(file) do |track, num_tracks, i|
    puts "Read track #{i} of #{num_tracks}"
  end
end

EM.run { 

# Iterate over every event in every track.
seq.each do |track|
    track.each do |event|
        # If the event is a note event (note on, note off, or poly
        # pressure) and it is on MIDI channel 5 (channels start at
        # 0, so we use 4), then transpose the event down one octave.
        if MIDI::NoteEvent === event #&& event.channel == 4
            #event.note -= 12
            #p event.methods
            #p event.note
            if event.channel == 7
              puts "#{event.channel} #{event.note} #{event.velocity} #{event.delta_time}"
              synth.play_note event.note, event.velocity, 0.2
              sleep event.delta_time.to_f / 1000
            end
        end
    end
end

}


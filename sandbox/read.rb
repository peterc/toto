require 'midilib'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'

# Create a new, empty sequence.
seq = MIDI::Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open('rickroll.mid', 'rb') do |file|
  seq.read(file) do |track, num_tracks, i|
    puts "Read track #{i} of #{num_tracks}"
  end
end

# Iterate over every event in every track.
seq.each do |track|
    track.each do |event|
        # If the event is a note event (note on, note off, or poly
        # pressure) and it is on MIDI channel 5 (channels start at
        # 0, so we use 4), then transpose the event down one octave.
        if MIDI::NoteEvent === event && event.channel == 4
            event.note -= 12
        end
    }
end


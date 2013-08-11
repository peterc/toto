#!/usr/bin/ruby
rick_notes = File.read("rick-notes-sharp")

notes = %w{C C# D D# E F F# G G# A A# B}

note_midi_map = Hash[(24..108).collect {|i|
  ["#{notes[i%notes.length]}#{i/notes.length - 1}", i] 
}]

note_midi_map.each_pair do |note_name, midi_val|
  rick_notes.gsub! note_name, midi_val.to_s
end

puts rick_notes.split.inspect
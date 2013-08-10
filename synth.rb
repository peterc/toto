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
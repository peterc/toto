class Autotune < Middleware
  def init
    @pattern = [0, 2, 5, 7, 9]         # pentatonic
    #@pattern = [0, 2, 4, 6, 7, 9, 11]  # lydian
    #@pattern = [0, 2, 3, 5, 7, 8, 10]  # aeolian

    @good_notes = []
    @corrections = {}

    36.step(72, 12) do |base|
      @pattern.each do |offset|
        @good_notes << base + offset
      end
    end

    36.upto(90) do |note|
      @corrections[note] = @good_notes.min { |a,b| (a - note).abs <=> (b - note).abs }
    end
  end

  def note_on(event)
    event[:message].note = @corrections[event[:message].note]
    event
  end
end
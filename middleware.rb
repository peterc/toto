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

# Load all of the middlewares from ./middleware
Dir[File.expand_path('..', __FILE__) + '/middleware/*.rb'].each { |f| require f }
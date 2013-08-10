class Middleware
  attr_accessor :synth

  def initialize(*args)
    @active = true
    self.class.enable
    init(*args)
  end

  def init(*args); end

  def self.disable; @active = false; end
  def self.enable; @active = true; end
  def self.active?; @active; end

  def active?; self.class.active?; end

  def any(event); event; end
  def note_on(event); event; end
  def note_off(event); event; end
  def control_change(event, knob, value); event; end
end

# Load all of the middlewares from ./middleware
Dir[File.expand_path('..', __FILE__) + '/middleware/*.rb'].each { |f| require f }
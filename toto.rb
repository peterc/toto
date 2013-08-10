require 'unimidi'
require 'midi-eye'
require 'eventmachine' 

require_relative 'synth'
require_relative 'processor'
require_relative 'middleware'


synth = Synth.new(UniMIDI::Input.open(1), UniMIDI::Output.open(0))

processor = Processor.new(synth)

processor.add_middleware Debugging
processor.add_middleware KnobNoise
processor.add_middleware MirrorKeyboard
processor.add_middleware Monitor

processor.start
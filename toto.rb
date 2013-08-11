require 'unimidi'
require 'midi-eye'
require 'eventmachine'

require_relative 'synth'
require_relative 'processor'
require_relative 'middleware'

synth = Synth.new(UniMIDI::Input.open(1), UniMIDI::Output.open(0))
processor = Processor.new(synth)


processor.add_middleware Debugging
processor.add_middleware PlayExternalAudio
processor.add_middleware KnobNoise
#processor.add_middleware MirrorKeyboard
#processor.add_middleware Echo
#processor.add_middleware Bender
#processor.add_middleware Autotune
processor.add_middleware Arpeggiator
processor.add_middleware Monitor


processor.add_middleware KnobControl.new(
  21 => Debugging,
  22 => KnobNoise,
  23 => MirrorKeyboard,
  24 => Monitor,
  25 => Arpeggiator,
  26 => Autotune
)

processor.start
var midi = require('midi');
var midiOut = new midi.output();
var midiIn = new midi.input();

var inPort = 1;
var outPort = 0;

midiOut.openPort(outPort);
midiIn.openPort(inPort);
console.log('out: ' + midiOut.getPortName(outPort));
console.log(' in: ' + midiIn.getPortName(inPort));

function playNote(note, velocity) {
  midiOut.sendMessage([144, note, velocity]);
  setTimeout(function() { midiOut.sendMessage([144, note, 0]); }, 200);
}

function playNoteIn(note, velocity, time) {
  setTimeout(function() { playNote(note, velocity); }, time);
}

playNoteIn(64, 40, 0);
playNoteIn(63, 30, 200);
playNoteIn(64, 40, 500);

midiIn.on('message', function(deltaTime, message) {
  if (message[0] == 208) return;
  console.log('m:' + message + ' d:' + deltaTime);
  message[1] = ((message[1] - 60) * -1) + 60;
  //message[1] = Math.abs(message[1] - 62) + 62;
  midiOut.sendMessage(message);
});
 
process.addListener("SIGTERM", function() {
  midiOut.closePort();
});

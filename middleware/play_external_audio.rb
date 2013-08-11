class PlayExternalAudio < Middleware
  def note_on(event)
    if event[:message].note == 84 && event[:message].velocity > 0
     pid = Process.spawn("afplay", File.expand_path('../../audio/sweat.aiff', __FILE__),
                     :out => '/dev/null', :err => '/dev/null')
 
 
     Process.detach pid
     return nil
    end
 
    if event[:message].note == 83 && event[:message].velocity > 0
     pid = Process.spawn("say", "\"we're up all night to get lucky\"",
                     :out => '/dev/null', :err => '/dev/null')
 
 
     Process.detach pid
     return nil
    end

    event
  end
end
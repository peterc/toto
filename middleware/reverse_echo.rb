class ReverseEcho < Middleware
  def init
    @echo_speed = 0.5
  end

  def note_on(event)
    msg = event[:message].dup
    final_velocity = msg.velocity

    EM.add_timer(@echo_speed) do
      msg.velocity = final_velocity / 3
      synth.puts msg
    end

    EM.add_timer(@echo_speed * 2) do
      msg.velocity = final_velocity / 2
      synth.puts msg
    end

    EM.add_timer(@echo_speed * 3) do
      msg.velocity = final_velocity
      synth.puts msg
    end

    nil
  end

  def control_change(event, knob, value)
    return unless knob == 28

    @echo_speed = 0.1 + value / 256.0

    event
  end
end
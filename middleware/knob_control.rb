class KnobControl < Middleware
  def init(*params)
    @middlewares = params.first || {}
  end

  def control_change(event, knob, value)
    if value < 64 && @middlewares[knob]
      @middlewares[knob].disable
    elsif value >= 64 && @middlewares[knob]
      @middlewares[knob].enable
    end

    event
  end
end

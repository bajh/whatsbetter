class Term

  attr_accessor :response, :content

  def initialize(content, client)
    @content  = content  
    @response = client.search(content).attrs[:statuses]
  end

  def length
    response.length
  end

  def results
    result = {}
    if measure_by_week?
      result[:count] = self.length
    else
      result[:seconds] = self.time_span
    end
    return result
  end

  def measure_by_week?
     if self.length > 0
      return time_span > 8_640_000 ? true : false
    end
    return true
    # (self.length < 7 || unpopular_tweet?) ? true : false
  end

  def unpopular_tweet?
    if self.length > 0
      return time_span > 8_640_000 ? true : false
    end
    return true
  end

  def stats
    if self.results[:count]
      return {num: self.length, unit: :week}
    else
      self.frequency
    end
  end

  def frequency
    #seconds
    if time_span == 0
      return {num: 101, unit: :second} 
    elsif time_span < 100
      ratio = self.length.to_f / time_span
      return {num: round_ratio(ratio), unit: :second}
    elsif time_span == 100
      return {num: 1, unit: :second}

    #minutes
    elsif time_span < 6000
      ratio = ( self.length.to_f / time_span) * 60
      return {num: round_ratio(ratio), unit: :minute}
    elsif time_span == 6000
      return {num: 1, unit: :minute}
    
    #hours
    elsif time_span < 360_000
      ratio = (( self.length.to_f / time_span) * 60) * 60
      return {num: round_ratio(ratio), unit: :hour}
    elsif time_span == 360_000
      return {num: 1, unit: :hour}
    

    #days, NEVER HAPPENS THO
    elsif time_span < 8_640_000
      ratio = ((( self.length.to_f / time_span) * 60) * 60) * 24
      return {num: round_ratio(ratio), unit: :day}
    elsif time_span == 8_640_000
      return {num: 1, unit: :day}
    end

  end

  def time_span
    Time.parse(self.response.first[:created_at]) - 
    Time.parse(self.response.last[:created_at])
  end

  def round_ratio(ratio)
    ratio = ratio == ratio.to_i ? ratio.to_i : ratio.round(2) 
  end



end
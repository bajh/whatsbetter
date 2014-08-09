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
    # (term.time_span < 1800 && term.length > 80) || term.length == 100 
    # if response > 0 THEN seconds_per_hundred and see if > 1800
    (self.length < 90 || unpopular_tweet?) ? true : false
  end

  def unpopular_tweet?
    if self.length > 0
      return time_span > 3599 ? true : false
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
    if time_span == 0
      return {num: 101, unit: :second} 
    elsif time_span < 100
      ratio = 100.0 / time_span
      return {num: round_ratio(ratio), unit: :second}
    elsif time_span == 100
      return {num: 1, unit: :second}
    elsif time_span < 
      ratio = ( 100.0 / time_span) * 60
      return {num: round_ratio(ratio), unit: :minute}
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
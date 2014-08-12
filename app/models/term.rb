class Term

  attr_accessor :response, :content

  def initialize(content, client)
    @content  = content  
    # binding.pry
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
    result
  end

  def measure_by_week?
    self.length < 90 || unpopular_tweet?
  end

  def unpopular_tweet?
    self.length > 0 ? time_span > 8_640_000 : true
  end

  def stats
    self.results[:count] ? self.count_frequency : self.frequency
  end

  def count_frequency
    if self.length < 7
      return {num: self.length, unit: :week}
    else
      return {num: (round_ratio(self.length.to_f / 7)), unit: :day}
    end
  end

  def frequency
    #seconds
    if time_span == 0
      return {num: 101, unit: :second} 
    elsif time_span <= self.length.to_f
      ratio = tweets_over_time
      return {num: round_ratio(ratio), unit: :second}
  
    #minutes
    elsif time_span <= 60 * self.length.to_f
      ratio = tweets_over_time(60)
      return {num: round_ratio(ratio), unit: :minute}
    
    #hours
    elsif time_span <= 3600 * self.length.to_f
      ratio = tweets_over_time(3600)
      return {num: round_ratio(ratio), unit: :hour}
    
    #days, ONLY > 90
    elsif time_span <= 86_400 * self.length.to_f
      ratio = tweets_over_time(86_400)
      return {num: round_ratio(ratio), unit: :day}
    end
  end

  def tweets_over_time(seconds = 1)
    (self.length.to_f / time_span) * seconds
  end 

  def time_span
    Time.parse(self.response.first[:created_at]) - 
    Time.parse(self.response.last[:created_at])
  end

  def round_ratio(ratio)
    ratio == ratio.to_i ? ratio.to_i : ratio.round(2) 
  end

  def self.suggestions
    ["Abraham Lincoln", "George Washington", "Space Jam", "#yolo", "Rabbits", "Dirty Laundry", "Barack Obama", "Flatiron School", "Ruby", "Casablanca", "Citizen Kane", "The Beatles", "The Rolling Stones", "Brad Pitt", "Cary Grant", "Science", "Religion", "War", "Peace", "Soccer", "Football", "Basketball", "Food", "Sleep", "Tired", "Mosquito", "Aladdin", "Martin Luther King Jr.", "Martin Luther", "Jessica Simpson", "Python", "Justin Bieber", "Michael Jackson", "Tofu Dogs", "Vegans", "Omnivores", "T-Rex", "Pogs", "Stamps", "New York", "Utah", "Nature", "Bill Nye", "Neil DeGrasse Tyson", "Seinfeld", "Friends", "Lion King", "Breaking Bad", "Captain Planet", "Bubbles", "Twizzlers", "Twisted Sister", "Happy Hour", "VHS Tapes", "Bongo Drums", "Snails", "Alabama", "Mercury", "Panama Canal", "Snow", "Cactus", "Cotton", "As I Lay Dying", "The Shadow", "Pancakes", "Yosemite", "Grand Canyon", "Yellowstone", "Walking", "Crying", "Smells", "Mankind", "Airports", "Big Willy Style", "Will Smith", "Love", "Art", "The Mona Lisa", "Starry Night", "The Scream", "#fml", "#selfie", "#omg", "Honey Boo Boo", "War", "Jane Austin", "Pride and Prejudice", "Jurassic Park", "Batman", "Superman", "Facebook", "Instagram", "Tumblr", "Woodchucks", "Paper", "Rock", "Scissors", "Chocolate", "Sour Patch Kids", "Adults", "Kids", "Pepperoni", "Pepper Spray", "Flying Squirrels", "Elephants", "Cats", "dogs", "Summer", "Winter", "Game of Thrones", "Peanut Butter and Jelly", "White Lies", "Brutal Honesty"]
  end

end
class ApplicationController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views/") }
  configure(:development) { set :session_secret, "something" }
  enable :sessions

  get '/' do
    @samples = Term.suggestions.sample(2)
    erb :index
  end

  get "/query" do
    q = Queryier.new(params[:term1], params[:term2])
    winner = q.winner.stats
    loser = q.loser.stats
    if q.winner.content == params[:term1]
      winner_id = 1
      loser_id = 2
    else
      winner_id = 2
      loser_id = 1
    end
    winner.merge!({content: q.winner.content, div_id: winner_id})
    loser.merge!({content: q.loser.content, div_id: loser_id})
    winning_tweet = q.random_winner_tweet 
    content_type :json 
    { winner: winner, loser: loser, winning_tweet: winning_tweet }.to_json
  end

end
# encoding: utf-8

class User
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :email,        String
  property :avatar,       String # path to avatar image
  property :reward,       Text
  property :reminder,     Date
  property :repeat,       Enum[:none, :daily, :weekly, :monthly]
  
  has n, :plans
  has n, :statistics
  
  is :authenticatable
end

User.fixture {{
  :name                  => Randgen.name,
  :email                 => "#{/\w+/.gen}@#{/\w+/.gen}.#{/co.uk|com|net|org/.gen}",
  :reward                => /[:sentence:]/.gen,
  :password              => (password = /\w+/.gen),
  :password_confirmation => password
}}

get '/user/:id.json' do |id|
  content_type :json
  
  user = User.get(id)
  
  user_data = {
    :id         => user.id,
    :name       => user.name,
    :email      => user.email,
    :avatar     => user.avatar,
    :reward     => user.reward,
    :reminder   => user.reminder,
    :repeat     => user.repeat,
    :goals      => user.plans.map {|p|
      {
        :plan_id     => p.id, 
        :goal_id     => p.goal.id, 
        :title       => p.goal.title, 
        :description => p.goal.description, 
        :done        => p.done, 
        :priority    => p.priority
      }
    },
    :statistics => user.statistics
  }
  
  user_data.to_json
end
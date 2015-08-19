class Facebook
  include Rails.application.routes.url_helpers
  attr_accessor :graph, :root_url

  def initialize(auth_token, root_url)
    @graph = Koala::Facebook::API.new(auth_token)
    @root_url = root_url
  end

  def default_post_to_wall (challenge, user)
    graph.put_wall_post("Please vote for me on ProveIt! I'm currently participating in a challenge called #{challenge.title.titleize}. Thank you!", {
      "name" => "ProveIt",
      "link" => "#{root_url}#{challenge_path(challenge.id)}",
      "caption" => "#{challenge.title.titleize}",
      "description" => "The site to challenge your friends",
      "picture" => "#{Evidence.find_by(:user_id => user.id, :challenge_id => challenge.id).photo.url}"
    }) 
  end

end
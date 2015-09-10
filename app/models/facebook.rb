class Facebook
  include Rails.application.routes.url_helpers
  attr_accessor :graph, :root_url

  def initialize(auth_token, root_url)
    @graph = Koala::Facebook::API.new(auth_token)
    @root_url = root_url
  end

  def post_to_wall (challenge, user, message)
    graph.put_wall_post("#{message}", {
      "name" => "ProveIt",
      "link" => "#{root_url}#{challenge_path(challenge.id)}",
      "caption" => "#{challenge.title.titleize}",
      "description" => "The site to challenge your friends",
      "picture" => "#{Evidence.find_by(:user_id => user.id, :challenge_id => challenge.id).photo.url}"
    }) 
  end

end
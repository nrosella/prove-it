

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) {|n| "dodo#{n}@gmail.com"}
    f.password "secret123"
    f.name "dodo"
end

  # This will use the User class (Admin would have been guessed)
  # factory :admin, class: User do
  #   first_name "Admin"
  #   last_name  "User"
  #   admin      true
  # end

end

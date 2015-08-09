FactoryGirl.define do
  factory :user do
    name "Nino Rosella"
    email "nino@nino.com"
    password "password123"
    # confirmation_password "password123"
    
  end

  # This will use the User class (Admin would have been guessed)
  # factory :admin, class: User do
  #   first_name "Admin"
  #   last_name  "User"
  #   admin      true
  # end

end

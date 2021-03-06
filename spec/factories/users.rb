

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) {|n| "dodo#{n}@gmail.com"}
    f.password "secret123"
    f.password_confirmation 'secret123'
    f.sequence(:name) {|n| "dodo#{n}" }
  end
end

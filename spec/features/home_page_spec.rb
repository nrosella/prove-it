require 'spec_helper'

describe 'my homepage' do 
  describe 'visiting the homepage', js: true do 
    visit root_path
    binding.pry
  end
  
end
require 'rails_helper'

RSpec.describe Challenge, type: :model do
  describe '#valid?' do
    let(:challenge){Challenge.new(title: title, challenged_id: id)}
    let(:title){"dalkjsfd"}
    let(:id){2}
    
    context 'when there is no title' do
      let(:title){nil}
      it 'invalidates if there is not a title' do
        
        expect(challenge).to_not be_valid
      end
    end

    context 'when there is no challenged user' do
      let(:id){nil}
      it 'invalidates if there is not a challenged user' do
        expect(challenge).to_not be_valid
      end
    end
  end
end

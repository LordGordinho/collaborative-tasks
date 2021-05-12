require 'rails_helper'

RSpec.describe Task, type: :model do
    let(:task) { build(:task) }
    it { expect(task).to be_valid }    

    it { is_expected.to belong_to(:user) }

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :user_id }
  
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:done) }

    it 'when tha task is new' do
        expect(task.done).to be_falsey
    end

    it { is_expected.to respond_to(:user_id) }
end

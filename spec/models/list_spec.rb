require 'rails_helper'

RSpec.describe List, type: :model do
    let(:list) { build(:list) }
    it { expect(list).to be_valid } 

    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:tasks).dependent(:destroy) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :user_id }
  
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:user_id) }
end

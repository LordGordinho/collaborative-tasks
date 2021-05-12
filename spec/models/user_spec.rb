require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { expect(user).to be_valid }    
  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  it { is_expected.to allow_value('teste@email.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
end

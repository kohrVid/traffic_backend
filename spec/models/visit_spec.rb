require 'rails_helper'

RSpec.describe Visit, type: :model do
  subject { build(:visit, user: user) }

  describe '#user' do
    context 'when it is missing' do
      let(:user) { nil }

      before { subject.save }

      it { is_expected.to be_valid }
    end
  end
end

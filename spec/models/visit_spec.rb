require 'rails_helper'

RSpec.describe Visit, type: :model do
  before do
    create(:visit)
  end

  describe '.with_info' do
    it 'includes location data for each visit' do
      debugger
    end
  end
end

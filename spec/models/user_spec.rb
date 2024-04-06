require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe ':username' do
      context 'when it is missing or blank' do
        let(:new_user) do
          User.new(username: '')
        end

        before { new_user.save }

        it 'is invalid' do
          expect(new_user).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_user.errors.messages[:username]
          ).to include("can't be blank")
        end
      end

      context 'when a record with the same username already exists' do
        let(:existing_user) { create(:user) }
        let(:new_user) do
          User.new(username: existing_user.username)
        end

        before do
          existing_user
          new_user.save
        end

        it 'is invalid' do
          expect(new_user).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_user.errors.messages[:username]
          ).to include("has already been taken")
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe State, type: :model do
	context 'relations' do
		it { is_expected.to belong_to(:feedback) }
	end

	context 'validations' do
		it { is_expected.to validate_presence_of(:device) }
		it { is_expected.to validate_presence_of(:os) }
	end
end

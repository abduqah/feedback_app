require 'rails_helper'

RSpec.describe Feedback, type: :model do
	
	context 'relations' do
		it { is_expected.to have_one :state }
	end

	it 'feedback priority enum value' do
		should define_enum_for(:priority).with(%i[minor major critical])
	end

	context 'validations' do
		subject { Feedback.new(company_token: "fdfadjhfnaef", number: 1) }
		it { is_expected.to validate_uniqueness_of(:number).scoped_to(:company_token) }
		it { is_expected.to validate_presence_of(:company_token) }
		it { is_expected.to validate_presence_of(:priority) }
	end

	context 'number count' do
		it 'increment the number by company_token' do
			feedback_one = create(:feedback, company_token: 'Lahje7')
			feedback_one = create(:feedback, company_token: 'uTs;mk')
			feedback_two = create(:feedback, company_token: 'uTs;mk')

			expect(feedback_one.number).to eql(1)
			expect(feedback_three.number).to eql(2)
		end
	end
end

RSpec.describe Feedback, search: true do
	it "feedback search by company token" do
		Feedback.create!(company_token: "xhIlm34")
		Feedback.search_index.refresh
		assert_equal ["xhIlm34"], Feedback.search("xhIlm34").map(&:company_token)
	end
end

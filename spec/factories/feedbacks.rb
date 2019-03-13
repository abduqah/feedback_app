
FactoryBot.define do
	factory :feedback do
	  company_token { SecureRandom.hex(9) }
	  priority { ['minor','major','critical'][rand(1..3)] }
	end
end
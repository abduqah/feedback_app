FactoryBot.define do
  factory :feedback do
    company_token { SecureRandom.hex(9) }
      priority { ['minor','major','critical'][rand(0..2)] }
      number { 19 }
  end
end
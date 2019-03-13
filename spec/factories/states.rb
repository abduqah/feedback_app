FactoryBot.define do
	factory :state do
		feedback
		device  %w[OnePlus HTC Pixel iPhone].sample
		os      %w[android iOS].sample
		memory  512.step(4096, 512).to_a.sample
		storage 512.step(128 * 1024, 512).to_a.sample
	end
end
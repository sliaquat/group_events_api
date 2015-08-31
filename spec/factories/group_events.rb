
FactoryGirl.define do

  factory :incomplete_group_event, class:GroupEvent do

    name FFaker::Lorem.word
    description FFaker::Lorem.paragraph


    factory :complete_group_event do
      location FFaker::AddressAU.full_address
      start_date Time.current
      end_date  Time.current + 1.day
      duration 1
    end

  end



end

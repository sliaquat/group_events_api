FactoryGirl.define do

  factory :incomplete_group_event, class: GroupEvent, aliases: [:group_event] do

    name FFaker::Lorem.word
    description FFaker::Lorem.paragraph


    factory :group_event_with_start_date_after_end_date do
      start_date Time.current + 1.day
      end_date Time.current
    end

    factory :group_event_with_same_start_and_end_date do
      start_date Time.current
      end_date Time.current
    end

    factory :incomplete_published_group_event do
      status 'published'
    end

    factory :complete_group_event do
      location FFaker::AddressAU.full_address
      start_date Time.current
      end_date Time.current + 1.day
      duration 1

      factory :complete_published_group_event do
        status 'published'
      end

    end

  end


end

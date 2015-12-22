FactoryGirl.define do
  sequence(:newData, 2) do |n|
    "newData_#{n}"
  end

  factory :event do
    data "a default data string"
  end

  factory :indexEvents, parent: :event do
    data { generate(:newData) }
  end
 end
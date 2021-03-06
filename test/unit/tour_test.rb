# == Schema Information
#
# Table name: tours
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  state               :string(255)
#  description         :string(255)
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city                :string(255)
#  zip                 :string(255)
#  subdivision         :string(255)
#  price               :float
#  square_footage      :integer
#  bed_rooms           :integer
#  bath_rooms          :integer
#  category_id         :integer
#  latitude            :float
#  longitude           :float
#  gmaps               :boolean
#  slug                :string(255)
#  address             :text
#  status              :integer
#  selected_package_id :integer
#  deleted_at          :datetime
#

#  id                  :integer          not null, primary key
#  name                :string(255)
#  state               :string(255)
#  description         :string(255)
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city                :string(255)
#  zip                 :string(255)
#  subdivision         :string(255)
#  price               :float
#  square_footage      :integer
#  bed_rooms           :integer
#  bath_rooms          :integer
#  category_id         :integer
#  latitude            :float
#  longitude           :float
#  gmaps               :boolean
#  slug                :string(255)
#  address             :text
#  status              :integer
#  selected_package_id :integer

#

require 'test_helper'

class TourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

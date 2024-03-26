require "test_helper"

class RfmDataServiceTest < ActiveSupport::TestCase
  setup do
    travel_to Date.new(2024,03,25)

    # Need to manually create record instead of using fixture because
    # the fixture yml file is not handle a newline properly when we try
    # to load the string that contains newline '\n' from database
    rfm_upload = RfmUpload.create(
      name: "rfm_orders_example.csv",
      body: File.read(Rails.root.join('test', 'fixtures', 'files', 'rfm_orders_example.csv'))
    )
    rfm_upload.insert_all!
  end

  test "transform_data" do
    # skip it as we turn this method into private method
    skip
    rfm = RfmDataService.new
    rfm.transform_data!

    first_customer = {
      :order_count=>1,
      :order_date=>"2024-01-15",
      :sum_amount=>598,
      :customer_name=>"ชื่อ ลูกค้า 29",
      :customer_phone=>"0851177042",
      :days=>71,
      :r_score=>1,
      :f_score=>2,
      :m_score=>1
    }
    last_customer = {
      :order_count=>10,
      :order_date=>"2024-02-22",
      :sum_amount=>13089,
      :customer_name=>"ก้องภพ ใจดี",
      :customer_phone=>"0812345678",
      :days=>33,
      :r_score=>2,
      :f_score=>5,
      :m_score=>5
    }
    assert_equal first_customer, rfm.data.first
    assert_equal last_customer, rfm.data.last
  end

  test "generate!" do
    rfm = RfmDataService.new
    rfm.generate!

    expected = {
      champion: {:customers=>15,:percentage=>15.0,:days=>14,:avrg_orders=>4.0,:avrg_spent=>4978.73},
      royal: {:customers=>23,:percentage=>23.0,:days=>29,:avrg_orders=>3.91,:avrg_spent=>4750.52},
      potential_royal: {:customers=>12,:percentage=>12.0,:days=>21,:avrg_orders=>1.92,:avrg_spent=>2107.42},
      new: {:customers=>0,:percentage=>0.0,:days=>0,:avrg_orders=>0,:avrg_spent=>0},
      promising: {:customers=>3,:percentage=>3.0,:days=>20,:avrg_orders=>1.0,:avrg_spent=>817.67},
      need_attention: {:customers=>3,:percentage=>3.0,:days=>23,:avrg_orders=>1.0,:avrg_spent=>1576.67},
      sleep: {:customers=>5,:percentage=>5.0,:days=>30,:avrg_orders=>2.2,:avrg_spent=>3085.2},
      cant_lose: {:customers=>7,:percentage=>7.0,:days=>54,:avrg_orders=>5.86,:avrg_spent=>7926.43},
      risk: {:customers=>10,:percentage=>10.0,:days=>71,:avrg_orders=>2.6,:avrg_spent=>3336.7},
      hibernating: {:customers=>22,:percentage=>22.0,:days=>84,:avrg_orders=>1.18,:avrg_spent=>1376.41}
    }
    assert_equal expected, rfm.data
  end
end

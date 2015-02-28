require 'test_helper'

class MeasurementTypeTest < ActiveSupport::TestCase
  
  def setup
    @mt = measurement_types(:weight)
  end
  
  test "should be valid" do
    assert @mt.valid?
  end
  
  test "empty name not valid" do
    @mt.measurement_name= "  "
    assert_not @mt.valid?
  end
  
  test "empty type not valid" do
    @mt.measurement_type = ""
    assert_not @mt.valid?
  end
   
  test "duplicate not valid" do
    mt2 = @mt.dup
    assert_not mt2.valid?
  end 
  
  test "duplicate type not valid" do
    m = MeasurementType.new(measurement_type: @mt.measurement_type, measurement_name: "myname")
    assert_not m.valid?
    m.measurement_type = "mytype"
    assert m.valid?
  end
  
  
  test "duplicate name not valid" do
    m = MeasurementType.new(measurement_type: "mytype2", measurement_name: @mt.measurement_name)
    assert_not m.valid?
    m.measurement_name = "myname2"
    assert m.valid?
  end
  
  test "can delete unused measurement" do
    assert_difference 'MeasurementType.count', -1 do
      @mt.destroy
    end
  end
  
  test "cannot delete used measurement" do
    salt = ingredients(:salt)
    salt.measurement_type = @mt
    assert salt.save, "#{salt.errors.full_messages}"
    assert_no_difference 'MeasurementType.count' do
      @mt.destroy
    end
  end
end

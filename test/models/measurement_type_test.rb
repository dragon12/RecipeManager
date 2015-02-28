require 'test_helper'

class MeasurementTypeTest < ActiveSupport::TestCase
  
  def setup
    @mt_with_ingredient = measurement_types(:weight)
    @mt_without_ingredient = measurement_types(:weight_without_ingredients)
  end
  
  test "should be valid" do
    assert @mt_with_ingredient.valid?, "#{@mt_with_ingredient.errors.full_messages}"
  end
  
  test "empty name not valid" do
    @mt_with_ingredient.measurement_name= "  "
    assert_not @mt_with_ingredient.valid?, "#{@mt_with_ingredient.errors.full_messages}"
  end
  
  test "empty type not valid" do
    @mt_with_ingredient.measurement_type = ""
    assert_not @mt_with_ingredient.valid?
  end
   
  test "duplicate not valid" do
    mt2 = @mt_with_ingredient.dup
    assert_not mt2.valid?
  end 
  
  test "duplicate type not valid" do
    m = MeasurementType.new(measurement_type: @mt_with_ingredient.measurement_type, measurement_name: "myname")
    assert_not m.valid?
    m.measurement_type = "mytype"
    assert m.valid?
  end
  
  
  test "duplicate name not valid" do
    m = MeasurementType.new(measurement_type: "mytype2", measurement_name: @mt_with_ingredient.measurement_name)
    assert_not m.valid?
    m.measurement_name = "myname2"
    assert m.valid?
  end
  
  test "can delete unused measurement" do
    assert_equal 0, @mt_without_ingredient.ingredients.count
    assert_difference 'MeasurementType.count', -1 do
      @mt_without_ingredient.destroy
    end
  end
  
  test "cannot delete used measurement" do
    assert_not_equal 0, @mt_with_ingredient.ingredients.count
    assert_no_difference 'MeasurementType.count' do
      @mt_with_ingredient.destroy
    end
  end
end

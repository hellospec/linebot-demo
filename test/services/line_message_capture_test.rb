require "test_helper"
# require "minitest/autorun"

class LineMessageCaptureTest < ActiveSupport::TestCase
  test "valid massage" do
    good_message = "ppt 300 producta fb"
    m = LineMessageCapture.new(good_message)

    assert m.valid?
    assert m.has_all_attributes?
    assert_equal "300", m.amount
    assert_equal "producta", m.product
    assert_equal "fb", m.sale_channel
  end

  test "also valid if value positions are not in order" do
    good_message = "ppt producta 300 fb"
    m = LineMessageCapture.new(good_message)

    assert m.valid?
    assert m.has_all_attributes?
    assert_equal "300", m.amount
    assert_equal "producta", m.product
    assert_equal "fb", m.sale_channel

    another_good_message = "ppt fb producta 300"
    m = LineMessageCapture.new(another_good_message)

    assert m.valid?
    assert m.has_all_attributes?
    assert_equal "300", m.amount
    assert_equal "producta", m.product
    assert_equal "fb", m.sale_channel
  end

  test "missing amount is an invalid message" do
    bad_message = "ppt producta fb"
    m = LineMessageCapture.new(bad_message)

    assert_not m.valid?
    assert_equal "amount is not found!", m.error
    assert_nil m.amount
    assert_nil m.product
    assert_nil m.sale_channel
  end

  test "missing or bad product name is an invalid message" do
    bad_product_message = "ppt productx 300 fb"
    m = LineMessageCapture.new(bad_product_message)

    assert_not m.valid?
    assert_equal "product is not found!", m.error
    assert_equal "300", m.amount
    assert_nil m.product
    assert_nil m.sale_channel

    missing_product_message = "ppt 300 fb"
    m = LineMessageCapture.new(missing_product_message)

    assert_not m.valid?
    assert_equal "product is not found!", m.error
    assert_equal "300", m.amount
    assert_nil m.product
    assert_nil m.sale_channel
  end

  test "not consider as a command message" do
    normal_message = "300 producta fb"
    m = LineMessageCapture.new(normal_message)

    assert_not m.has_all_attributes?
    assert_not m.valid?
  end
end

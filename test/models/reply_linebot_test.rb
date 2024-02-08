require 'test_helper'
require 'minitest/autorun'

class ReplyLinebotTest < ActiveSupport::TestCase
  include ReplyLinebot

  class MatchMessage < ReplyLinebotTest
    test "ppx 100 with 1 whitespace" do
      message = "ppx 100"
      assert match_message("ppx 100")
    end
  
    test "ppx 100 with 2 whitespace" do
      message = "ppx  100"
      assert match_message("ppx  100")
    end

    test "ppx 100." do
      message = "ppx 100."
      assert match_message("ppx 100.")
    end

    test "ppx 100 abc" do
      message = "ppx 100 abc"
      assert match_message("ppx 100 abc")
    end

    test "ppx 100 200" do
      message = "ppx 100 200"
      assert match_message(message)
    end
  end

  class NotMatchMessage < ReplyLinebotTest
    test "ppx" do
      message = "ppx"
      refute match_message(message)
    end

    test "ppx abc100." do
      message = "ppx abc100."
      refute match_message(message)
    end

    test "ppx abc 100." do
      message = "ppx abc 100."
      refute match_message(message)
    end

    test "ppx 100abc" do
      message = "ppx 100abc"
      refute match_message(message)
    end
  end
end
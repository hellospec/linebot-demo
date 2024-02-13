require "test_helper"
require "minitest/autorun"

class ReplyLinebotTest < ActiveSupport::TestCase
  include ReplyLinebot

  class MatchMessage < ReplyLinebotTest
    test "ppx 100 with 1 whitespace" do
      assert match_message("ppx 100")
    end

    test "ppx 100 with 2 whitespace" do
      assert match_message("ppx  100")
    end

    test "ppx 100." do
      assert match_message("ppx 100.")
    end

    test "ppx 100 abc" do
      assert match_message("ppx 100 abc")
    end

    test "ppx 100 200" do
      assert match_message(message)
    end
  end

  class NotMatchMessage < ReplyLinebotTest
    test "ppx" do
      refute match_message(message)
    end

    test "ppx abc100." do
      refute match_message(message)
    end

    test "ppx abc 100." do
      refute match_message(message)
    end

    test "ppx 100abc" do
      refute match_message(message)
    end
  end
end

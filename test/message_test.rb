require 'beefcake/message'

class SimpleMessage
  include Beefcake::Message
  optional :a, :string, 1
  optional :b, :int32,  2
end


class MessageTest < Test::Unit::TestCase
  def test_encode
    msg = SimpleMessage.new :a => "testing", :b => 2
    assert_equal "\012\007testing\020\002", msg.encode("")
  end
end

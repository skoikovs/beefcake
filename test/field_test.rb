require 'beefcake/field'

class BeefcakeFieldTest < Test::Unit::TestCase
  class Encodable < String
    def encode(w)
      w << self
    end
  end

  def e(*v)
    value = v.pop
    field = Beefcake::Field.new(*v)
    field.value = value
    field.encode("")
  end

  def test_simple
    assert_equal "\010\001", e(:int32, 1, 1)
    assert_equal "\012\007testing", e(:string, 1, "testing")
    assert_equal "\012\007testing", e(Encodable, 1, Encodable.new("testing"))
  end
end

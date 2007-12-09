require 'test/unit'

class ChartrTest < Test::Unit::TestCase
  
  def test_encodings
    values = [0,62]
    encoding = Chartr.simple_encode(values)
    assert_equal encoding, 's:a9'
  end
  
  def test_simple_charts
  end
  
end

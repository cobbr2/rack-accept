require File.dirname(__FILE__) + '/helper'

class HeaderTest < Test::Unit::TestCase

  H = Rack::Accept::Header

  def test_parse_and_join
    # Accept
    header = 'text/plain; q=0.5, text/html, text/html;level=2, text/html;level=1;q=0.3, text/x-c, image/*; q=0.2'
    expect = {
      'text/plain'        => 0.5,
      'text/html'         => 1,
      'text/html;level=2' => 1,
      'text/html;level=1' => 0.3,
      'text/x-c'          => 1,
      'image/*'           => 0.2
    }
    assert_equal(expect, H.parse(header))
    assert_equal(expect, H.parse(H.join(expect)))

    # Accept-Charset
    header = 'iso-8859-5, unicode-1-1;q=0.8'
    expect = { 'iso-8859-5' => 1, 'unicode-1-1' => 0.8 }
    assert_equal(expect, H.parse(header))
    assert_equal(expect, H.parse(H.join(expect)))

    # Accept-Encoding
    header = 'gzip;q=1.0, identity; q=0.5, *;q=0'
    expect = { 'gzip' => 1, 'identity' => 0.5, '*' => 0 }
    assert_equal(expect, H.parse(header))
    assert_equal(expect, H.parse(H.join(expect)))

    # Accept-Language
    header = 'da, en-gb;q=0.8, en;q=0.7'
    expect = { 'da' => 1, 'en-gb' => 0.8, 'en' => 0.7 }
    assert_equal(expect, H.parse(header))
    assert_equal(expect, H.parse(H.join(expect)))
  end

  def test_parse_media_type
    assert_equal([], H.parse_media_type(''))
    assert_equal(['*', '*', ''], H.parse_media_type('*/*'))
    assert_equal(['text', '*', ''], H.parse_media_type('text/*'))
    assert_equal(['text', 'html', ''], H.parse_media_type('text/html'))
    assert_equal(['text', 'html', 'level=1'], H.parse_media_type('text/html;level=1'))
    assert_equal(['text', 'x-dvi', ''], H.parse_media_type('text/x-dvi'))
  end

end

require "test/unit"
require "microformats2"

class TestMicroformats2 < Test::Unit::TestCase
  def test_throw_exception_on_non_string_params
    assert_raise Microformats2::LoadError do
      Microformats2.parse(nil)
    end
  end

  def test_returns_hash_of_microformat_objects
    result = Microformats2.parse("A String")
    assert_equal Hash, result.class
  end

  def test_only_parse_microformats
    result = Microformats2.parse("<html><body><p>Something</p></body></html>")
    assert_equal 0, result.size
  end

  def test_extracts_hcard_from_an_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "simple.html")))
    assert_equal HCard, result[:hcard].first.class
    assert_equal 2, result[:hcard].length
  end

  def test_extracts_name_from_tag_with_multiple_classes
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "simple.html")))
    assert_equal "Chris", result[:hcard].first.given_name
  end

  def test_extracts_hcalendar_from_an_indiewebcamp_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "IndieWebCamp.html")))
    assert_equal 1, result[:hevent].length
    assert result[:hcard].map { |h| h.name }.include?("Urban Airship")
  end

  def test_extracts_dates_in_an_hcalendar_from_an_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "hcalendar.html")))
    assert_equal result[:hevent].first.dtstart, DateTime.parse("2007-09-08")
  end

  def test_extracts_date_durations_as_a_string_from_an_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "hcalendar.html")))
    assert_equal result[:hevent].first.duration, "P2D"
  end

  def test_turns_class_values_of_class_to_klass_from_an_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "hcalendar.html")))
    assert_equal result[:hevent].first.klass, "public"
  end

  def test_extracts_hcalendar_from_an_html_file
    result = Microformats2.parse(File.open(File.join(File.dirname(__FILE__), "IndieWebCamp.html")))
    assert_equal 1, result[:hevent].length
    assert result[:hcard].map { |h| h.name }.include?("Urban Airship")
  end

  def test_extracts_hcard_from_html
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">Chris</h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    assert_equal HCard, result[:hcard].first.class
  end

  def test_constructs_properties_from_hcard
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">
        <a class="p-fn u-url" href="http://factoryjoe.com/">
          <span class="p-given-name">Chris</span>
          <abbr class="p-additional-name">R.</abbr>
          <span class="p-family-name">Messina</span>
        </a>
      </h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    mycard = result[:hcard].first

    assert_equal "Chris", mycard.given_name
    assert_equal "R.", mycard.additional_name
    assert_equal "Messina", mycard.family_name
    assert_equal "Chris R. Messina", mycard.fn
  end

  def test_constructs_dates
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">
        <span class="d-bday">1979-09-18</span>
        <span class="d-epoch" title="1970-01-01">EPOCH!</span>
      </h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    mycard = result[:hcard].first

    assert_equal DateTime.parse("1979-09-18"), mycard.bday
    assert_equal DateTime.parse("1970-01-01"), mycard.epoch
  end

  def test_constructs_times
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">
        <span class="t-start">09:30</span>
        <span class="t-end" title="6:00">Leaving time</span>
      </h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    mycard = result[:hcard].first

    assert_equal Time.parse("09:30"), mycard.start
    assert_equal Time.parse("06:00"), mycard.end
  end

  def test_ignores_pattern_matches_not_at_the_beginning_of_class
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">
        <span class="p-n-x">Chris</span>
      </h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    mycard = result[:hcard].first

    assert_equal "Chris", mycard.n_x
    assert mycard.n_x.is_a?(String)
  end

  def test_constructs_urls_from_hcard
    hcard = <<-END
    <html>
    <head>
      <title>Simple hCard</title>
    </head>

    <body>
      <h1 class="h-card">
        <a class="p-fn u-url" href="http://factoryjoe.com/">Chris</a>
      </h1>
    </body>
    </html>
    END
    result = Microformats2.parse(hcard)
    mycard = result[:hcard].first
    assert_equal "http://factoryjoe.com/", mycard.url
  end
end

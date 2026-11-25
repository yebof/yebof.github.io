require 'minitest/autorun'
require_relative '../_plugins/corresponding_authors'

class CorrespondingAuthorsTest < Minitest::Test
  include CorrespondingAuthors

  def test_empty_and_missing
    [nil, '', '  '].each { |value| assert_equal [], corresponding_author_keys(value) }
  end

  def test_single_and_multiple_names
    assert_equal ['yebo feng'], corresponding_author_keys('Yebo Feng')
    assert_equal ['yebo feng', 'konglin zhu'], corresponding_author_keys('Feng, Yebo and Konglin Zhu')
    assert_equal ['yebo feng'], corresponding_author_keys('Yebo Feng and Feng, Yebo')
  end

  def test_full_name_matching
    assert_equal 'yebo feng', corresponding_author_key('first' => ' Yebo ', 'last' => 'Feng*')
    refute_includes corresponding_author_keys('Yebo Feng'), corresponding_author_key(first: 'Yebo', last: 'Fengson')
    refute_includes corresponding_author_keys('Yang Liu'), corresponding_author_key(first: 'Yu', last: 'Liu')
  end

  # Render the actual author block used by both publication lists.
  def render_authors(value, limit = nil)
    source = File.read(File.expand_path('../_layouts/bib.html', __dir__))
    block = source.split('<div class="author">', 2).last.split('<!-- Journal/Book title and date -->', 2).first
    Liquid::Template.parse(block).render!(
      'entry' => { 'corresponding' => value, 'author_array' => [
        { 'first' => 'Yebo', 'last' => 'Feng' }, { 'first' => 'Konglin', 'last' => 'Zhu' }
      ] },
      'site' => { 'scholar' => { 'first_name' => ['Yebo'], 'last_name' => ['Feng'] },
                  'data' => { 'coauthors' => {} }, 'max_author_limit' => limit }
    )
  end

  def test_actual_template
    assert_equal 0, render_authors(nil).scan('class="corresponding-author"').size
    assert_equal 0, render_authors('').scan('class="corresponding-author"').size
    assert_equal 1, render_authors('Yebo Feng').scan('class="corresponding-author"').size
    html = render_authors('Feng, Yebo and Zhu, Konglin')
    assert_equal 2, html.scan('class="corresponding-author"').size
    assert_includes html, '<em>Yebo Feng</em><span class="corresponding-author"'
    assert_includes render_authors('Konglin Zhu', 1), 'Konglin Zhu ✉'
  end
end

require 'minitest/autorun'
require 'liquid'
require 'bibtex'
require 'ostruct'
require_relative '../_plugins/hideCustomBibtex'

class BibtexMonthTest < Minitest::Test
  def format_bib(input)
    Liquid::Template.parse('{{ bib | hideCustomBibtex }}').render!(
      { 'bib' => input },
      registers: { site: OpenStruct.new(config: { 'filtered_bibtex_keywords' => ['corresponding', 'equal_contribution'] }) }
    )
  end

  def test_all_standard_months
    %w[January February March April May June July August September October November December].each do |name|
      assert_equal "  month = {#{name}},\n", format_bib("  month = #{name[0, 3].downcase},\n")
    end
  end

  def test_preserve_literals_and_other_fields
    ['{October}', '{September/October}', '"October"', '10'].each do |value|
      input = "  month = #{value},\n  title = {October research},\n"
      assert_equal input, format_bib(input)
    end
    assert_equal "  month = {October}\n", format_bib("  month = OCT\n")
  end

  def test_actual_paper_serialization
    bib = BibTeX.open(File.expand_path('../_bibliography/papers.bib', __dir__))
    output = format_bib(bib['liang2026synerfuzz'].to_s)
    assert_includes output, 'month = {October}'
    assert_empty BibTeX.parse(output).errors
  end

  def test_custom_fields_still_hidden
    assert_equal "  month = {May}\n", format_bib("  corresponding = {Yebo Feng},\n  month = may\n")
    assert_equal "  month = {May}\n", format_bib("  equal_contribution = {Wei Qiao and Yebo Feng},\n  month = may\n")
  end
end

 module Jekyll
  module HideCustomBibtex
    def hideCustomBibtex(input)
	  keywords = @context.registers[:site].config['filtered_bibtex_keywords']

	  keywords.each do |keyword|
		input = input.gsub(/^.*\b#{keyword}\b *= *\{.*$\n/, '')
	  end

      # bibtex-ruby serializes month names as macros (e.g. oct). Expand
      # standard macros to braced literals for the copyable citation.
      months = %w[January February March April May June July August September October November December]
      input.gsub(/^([ \t]*month[ \t]*=[ \t]*)(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)([ \t]*,?[ \t]*)$/i) do
        prefix, macro, suffix = Regexp.last_match.captures
        month = months.find { |name| name[0, 3].casecmp(macro).zero? }
        "#{prefix}{#{month}}#{suffix}"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::HideCustomBibtex)

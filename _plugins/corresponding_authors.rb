require 'bibtex'
require 'liquid'

module CorrespondingAuthors
  # Match complete names, never substrings or last names alone.
  def corresponding_author_key(author)
    first = author['first'] || author[:first]
    last = author['last'] || author[:last]
    "#{first} #{last}".gsub(/[¶&*†^]/, '').gsub(/\s+/, ' ').strip.downcase
  end

  def corresponding_author_keys(value)
    return [] if value.to_s.strip.empty?

    BibTeX::Names.parse(value.to_s).map do |name|
      corresponding_author_key('first' => name.first.to_s, 'last' => name.last.to_s)
    end.uniq
  end
end

Liquid::Template.register_filter(CorrespondingAuthors)

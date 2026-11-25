# Corresponding authors

Add the optional `corresponding` field to an entry in `_bibliography/papers.bib`:

```bibtex
corresponding={},
corresponding={Yebo Feng},
corresponding={Yebo Feng and Konglin Zhu},
```

These are three alternatives: use at most one field per paper. Omit the field
or leave it empty when no authors should be marked. Separate multiple names
with BibTeX's `and`, not commas. `Feng, Yebo and Zhu, Konglin` is also supported.
Use the same complete names as the paper's `author` field; initials are not
automatically expanded. Matching ignores case and extra whitespace.

The shared publication template adds an envelope after each matching author
on both Publications and Selected Publications. Existing author links and
emphasis are preserved. The envelope is a correspondence marker, not an email
link. Hidden authors retain an envelope marker when expanded.

This display-only field is omitted from the exported Bib citation. No existing
paper's corresponding authors are inferred automatically.

Run the regression tests with `ruby test/corresponding_authors_test.rb`.

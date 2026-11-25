require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'liquid'
require_relative '../_plugins/cache-bust'

class CssCacheTest < Minitest::Test
  include Jekyll::CacheBust

  def test_sass_changes_invalidate_stylesheet_url
    Dir.mktmpdir do |directory|
      Dir.chdir(directory) do
        FileUtils.mkdir_p('_sass')
        File.write('_sass/_base.scss', '.author { color: black; }')
        before = bust_css_cache('/assets/css/main.css')
        refute_equal '/assets/css/main.css?' + Digest::MD5.hexdigest(''), before
        assert_equal before, bust_css_cache('/assets/css/main.css')

        File.write('_sass/_base.scss', '.author { color: blue; }')
        refute_equal before, bust_css_cache('/assets/css/main.css')
      end
    end
  end
end

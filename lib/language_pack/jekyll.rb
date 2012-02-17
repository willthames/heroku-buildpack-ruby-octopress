require "language_pack"
require "language_pack/rack"

# Jekyll Language Pack.
class LanguagePack::Jekyll < LanguagePack::Rack

  # detects if this is a valid Jekyll site by seeing if "_config.yml" exists
  # @return [Boolean] true if it's a Jekyll app
  def self.use?
    super && File.exist?("_config.yml")
  end

  def name
    "Jekyll"
  end

  def compile
    super
    allow_git do
      generate_jekyll_site
    end
  end

  private

  def generate_jekyll_site
    topic("Building Jekyll site")
    pipe("env PATH=$PATH bundle exec jekyll 2>&1")
  end
end

require "language_pack"
require "language_pack/rack"

# Octopress Language Pack.
class LanguagePack::Octopress < LanguagePack::Rack

  # detects if this is a valid Octopress site by seeing if "_config.yml" exists
  # and the Rakefile
  # @return [Boolean] true if it's a Rack app
  def self.use?
    super && File.exist?("_config.yml") &&
    File.read("Rakefile") =~ /task :generate/
  end

  def name
    "Octopress"
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
    if File.read(".slugignore") =~ /plugins|sass|source/
      error ".slugignore contains #{$&}. Jekyll generation will fail."
    end
    pipe("env PATH=$PATH bundle exec rake generate 2>&1")
  end
end
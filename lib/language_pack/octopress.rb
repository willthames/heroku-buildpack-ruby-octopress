require "language_pack"
require "language_pack/jekyll"

# Octopress Language Pack.
class LanguagePack::Octopress < LanguagePack::Jekyll

  def self.use?
    super && has_generate_task?
  end

  def self.has_generate_task?
    File.read("Rakefile") =~ /task :generate/
  rescue Errno::ENOENT
    false
  end

  def name
    "Octopress"
  end

  def generate_jekyll_site
    topic("Building Jekyll site")
    if File.read(".slugignore") =~ /plugins|sass|source/
      error ".slugignore contains #{$&}. Jekyll generation will fail."
    end
    pipe("env PATH=$PATH bundle exec rake generate 2>&1")
  end
end


# Gem::Specification for Camptweet-0.8
# Originally generated by Echoe

Gem::Specification.new do |s|
  s.name = %q{camptweet}
  s.version = "0.8.0"
  s.authors = ["Brian Dainton"]
  s.description = %q{A simple daemon that polls for updated Twitter statuses and posts them to a Campfire room.}
  s.email = %q{brian.dainton@gmail.com}
  s.executables = ["camptweet", "camptweetd_base"]
  s.extra_rdoc_files = ["bin/camptweet", "bin/camptweetd_base", "CHANGELOG", "lib/camptweet/bot.rb", "lib/camptweet.rb", "LICENSE", "README.rdoc"]
  s.files = ["bin/camptweet", "bin/camptweetd_base", "CHANGELOG", "init.rb", "lib/camptweet/bot.rb", "lib/camptweet.rb", "LICENSE", "README.rdoc", "Manifest", "camptweet.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bdainton/camptweet}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Camptweet", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{A simple daemon that polls for updated Twitter statuses and posts them to a Campfire room.}

  s.add_dependency(%q<twitter4r>, [">= 0.3.0"])
  s.add_dependency(%q<tinder>, [">= 0.1.6"])
end
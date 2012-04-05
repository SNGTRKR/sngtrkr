# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "scrobbler"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker, Jonathan Rudenberg"]
  s.date = "2009-04-13"
  s.description = "wrapper for audioscrobbler (last.fm) web services"
  s.email = "nunemaker@gmail.com"
  s.extra_rdoc_files = ["lib/scrobbler/album.rb", "lib/scrobbler/artist.rb", "lib/scrobbler/base.rb", "lib/scrobbler/chart.rb", "lib/scrobbler/playing.rb", "lib/scrobbler/rest.rb", "lib/scrobbler/scrobble.rb", "lib/scrobbler/simpleauth.rb", "lib/scrobbler/tag.rb", "lib/scrobbler/track.rb", "lib/scrobbler/user.rb", "lib/scrobbler/version.rb", "lib/scrobbler.rb", "README.rdoc"]
  s.files = ["lib/scrobbler/album.rb", "lib/scrobbler/artist.rb", "lib/scrobbler/base.rb", "lib/scrobbler/chart.rb", "lib/scrobbler/playing.rb", "lib/scrobbler/rest.rb", "lib/scrobbler/scrobble.rb", "lib/scrobbler/simpleauth.rb", "lib/scrobbler/tag.rb", "lib/scrobbler/track.rb", "lib/scrobbler/user.rb", "lib/scrobbler/version.rb", "lib/scrobbler.rb", "README.rdoc"]
  s.homepage = "http://scrobbler.rubyforge.org"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Scrobbler", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "scrobbler"
  s.rubygems_version = "1.8.21"
  s.summary = "wrapper for audioscrobbler (last.fm) web services"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.4.86"])
    s.add_dependency(%q<activesupport>, [">= 1.4.2"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end

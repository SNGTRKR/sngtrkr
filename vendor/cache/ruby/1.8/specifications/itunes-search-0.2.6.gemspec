# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "itunes-search"
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["jeff durand"]
  s.date = "2011-06-15"
  s.description = "Pretty simple interface for the itunes search api will return results as array of results objects and offer reasonable accessor methods variables"
  s.email = "jeff.durand@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/johnnyiller/itunes-search"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "Itunes Search"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

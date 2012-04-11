# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rbrainz"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philipp Wolfer", "Nigel Graham"]
  s.date = "2011-04-27"
  s.description = "    RBrainz is a Ruby client library to access the MusicBrainz XML\n    web service. RBrainz supports the MusicBrainz XML Metadata Version 1.2,\n    including support for labels and extended release events.\n    \n    RBrainz follows the design of python-musicbrainz2, the reference\n    implementation for a MusicBrainz client library. Developers used to\n    python-musicbrainz2 should already know most of RBrainz' interface.\n    However, RBrainz differs from python-musicbrainz2 wherever it makes\n    the library more Ruby like or easier to use.\n"
  s.email = "phw@rubyforge.org"
  s.extra_rdoc_files = ["doc/README.rdoc", "LICENSE", "TODO", "CHANGES"]
  s.files = ["doc/README.rdoc", "LICENSE", "TODO", "CHANGES"]
  s.homepage = "http://rbrainz.rubyforge.org"
  s.require_paths = ["lib"]
  s.requirements = ["Optional: mb-discid >= 0.1.2 (for calculating disc IDs)"]
  s.rubyforge_project = "rbrainz"
  s.rubygems_version = "1.8.17"
  s.summary = "Ruby library for the MusicBrainz XML web service."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

# -*- coding: utf-8 -*-
# $Id: test_release_group.rb 271 2009-05-24 22:15:31Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test_entity'

# Unit test for the Release model.
class TestReleaseGroup < Test::Unit::TestCase

  def setup
    @tested_class = Model::ReleaseGroup
    @invalid_entity_types = [:artist, :track, :label, :release]
    @releases = [Model::Release.new, Model::Release.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_release_group
    release_group = nil
    assert_nothing_raised {release_group = Model::ReleaseGroup.new}
    assert release_group.is_a?(Model::Entity)
    
    mbid = Model::MBID.new('a07cbaff-aa79-35a9-9932-af7335f306eb', :release_group)
    assert_nothing_raised {release_group = Model::ReleaseGroup.new(
      mbid,
      'In Requiem'
      )}
    assert_equal mbid, release_group.id
    assert_equal 'In Requiem', release_group.title
  end
  
  def test_title
    release_group = Model::ReleaseGroup.new
    assert release_group.title.nil?
    assert_nothing_raised {release_group.title = 'Draconian Times'}
    assert_equal 'Draconian Times', release_group.title
    assert_equal 'Draconian Times', release_group.to_s
  end

  def test_types
    release_group = Model::ReleaseGroup.new
    assert_equal 0, release_group.types.size
    types = []
    assert_nothing_raised {
      types = [Model::ReleaseGroup::TYPE_NONE,
               Model::ReleaseGroup::TYPE_NON_ALBUM_TRACKS,
               Model::ReleaseGroup::TYPE_ALBUM,
               Model::ReleaseGroup::TYPE_SINGLE,
               Model::ReleaseGroup::TYPE_EP,
               Model::ReleaseGroup::TYPE_SOUNDTRACK,
               Model::ReleaseGroup::TYPE_SPOKENWORD,
               Model::ReleaseGroup::TYPE_INTERVIEW,
               Model::ReleaseGroup::TYPE_AUDIOBOOK,
               Model::ReleaseGroup::TYPE_LIVE,
               Model::ReleaseGroup::TYPE_REMIX,
               Model::ReleaseGroup::TYPE_OTHER,
               ]
    }
    
    # Adding all those types should be possible.
    types.each {|type|
      assert_nothing_raised {release_group.types << type}
    }
    assert_equal 12, release_group.types.size
    
    # Removing the types again
    types.each {|type|
      assert_nothing_raised {release_group.types.delete type}
    }
    assert_equal 0, release_group.types.size
  end

  def test_artist
    release_group = Model::ReleaseGroup.new
    artist = Model::Artist.new
    assert release_group.artist.nil?
    assert_nothing_raised {release_group.artist = artist}
    assert_equal artist, release_group.artist
  end
  
  # Many releases can be added
  def test_add_and_remove_releases
    release_group = Model::ReleaseGroup.new
    assert_equal 0, release_group.releases.size
    assert_nothing_raised {release_group.releases << @releases[0]}
    assert_equal 1, release_group.releases.size
    assert_nothing_raised {release_group.releases << @releases[1]}
    assert_equal 2, release_group.releases.size
    
    assert_nothing_raised {release_group.releases.delete @releases[1]}
    assert_equal 1, release_group.releases.size
    assert_nothing_raised {release_group.releases.delete @releases[0]}
    assert_equal 0, release_group.releases.size
  end
  
end

# -*- coding: utf-8 -*-
# $Id: test_release_group_filter.rb 273 2009-05-24 22:29:04Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'testing_helper'
require 'rbrainz'
include MusicBrainz

# Unit test for the ReleaseFilter class.
class TestReleaseGroupFilter < Test::Unit::TestCase

  def setup
    @filter_hash = {
      :title        => 'Haven',
      :artist       => 'Dark Tranquillity',
      :artistid     => '9d30e408-1559-448b-b491-2f8de1583ccf',
      :releasetypes => 'Album Official',
      :limit        => 10,
      :offset       => 20,
      :query        => 'title:Haven'
      }
  end

  def teardown
  end
  
  def test_filter
    filter = Webservice::ReleaseGroupFilter.new(@filter_hash)
    filter_string = filter.to_s
    assert_not_equal '&', filter_string[0]
    
    result_hash = query_string_to_hash filter_string
    assert_equal @filter_hash[:title], result_hash['title'], filter_string
    assert_equal @filter_hash[:artist], result_hash['artist'], filter_string
    assert_equal @filter_hash[:artistid], result_hash['artistid'], filter_string
    assert_equal @filter_hash[:releasetypes], result_hash['releasetypes'], filter_string
    assert_equal @filter_hash[:limit].to_s, result_hash['limit'], filter_string
    assert_equal @filter_hash[:offset].to_s, result_hash['offset'], filter_string
    assert_equal @filter_hash[:query].to_s, result_hash['query'], filter_string
  end
  
  def test_release_types_as_array
    filter = Webservice::ReleaseGroupFilter.new(:releasetypes => [Model::ReleaseGroup::TYPE_ALBUM, 'Official'])
    filter_string = filter.to_s
    assert_not_equal '&', filter_string[0]
    
    result_hash = query_string_to_hash filter_string
    assert_equal 'Album Official', result_hash['releasetypes'], filter_string
  end
  
  def test_empty_filter
    filter = Webservice::ReleaseGroupFilter.new({})
    assert_equal '', filter.to_s
  end
  
end

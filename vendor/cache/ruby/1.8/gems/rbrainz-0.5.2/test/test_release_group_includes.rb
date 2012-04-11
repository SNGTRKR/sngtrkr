# -*- coding: utf-8 -*-
# $Id: test_release_group_includes.rb 254 2009-05-13 20:04:36Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the ReleaseIncludes class.
class TestReleaseGroupIncludes < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_includes
    includes = Webservice::ReleaseGroupIncludes.new(
      :artist => true,
      :releases => true
      )
    result_string = includes.to_s
    assert_equal 'inc=', result_string[0..3]
    
    result_array = result_string[4..-1].split(/%20|\+/)
    assert result_array.include?('artist')
    assert result_array.include?('releases')
  end
  
  def test_empty_includes
    includes = Webservice::ReleaseGroupIncludes.new(
      :artist => false,
      :releases => false
      )
    assert_equal '', includes.to_s
  
    includes = Webservice::ReleaseGroupIncludes.new({})
    assert_equal '', includes.to_s
  end
  
end

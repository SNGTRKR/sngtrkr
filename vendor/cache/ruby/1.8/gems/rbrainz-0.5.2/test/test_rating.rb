# -*- coding: utf-8 -*-
# $Id: test_rating.rb 254 2009-05-13 20:04:36Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Tag model.
class TestRating < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_rating
    rating = nil
    assert_nothing_raised {rating = Model::Rating.new}
    assert rating.empty?
    rating.value = 3.3
    rating.count = 12
    assert_equal 3.3, rating.value
    assert_equal 3.3, rating.to_f
    assert_equal 3, rating.to_i
    assert_equal '3.3', rating.to_s
    assert_equal 12, rating.count
    assert_equal false, rating.empty?
    
    assert_nothing_raised {rating = Model::Rating.new(5)}
    assert_equal 5.0, rating.value
    assert_equal nil, rating.count
    assert_equal false, rating.empty?
  
    assert_nothing_raised {rating = Model::Rating.new(1.0, 11)}
    assert_equal 1.0, rating.value
    assert_equal 11, rating.count
    assert_equal false, rating.empty?
  end
  
end

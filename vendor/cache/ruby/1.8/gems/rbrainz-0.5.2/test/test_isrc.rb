# -*- coding: utf-8 -*-
# $Id: test_isrc.rb 263 2009-05-24 22:15:12Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Tag model.
class TestISRC < Test::Unit::TestCase

  def setup
    @valid_raw_isrc = 'USPR37300012'
    @valid_printable_isrc = 'US-PR3-73-00012'
    @invalid_isrcs = ['', 'USPR37300012X', 'USPR3730001', 'ÜSPR37300012',
                      'USPR_7300012', 'USPR37300012-', '-USPR37300012']
  end

  def teardown
  end
  
  def test_parse_valid_raw_isrc
    isrc = nil
    assert_nothing_raised {isrc = Model::ISRC.parse(@valid_raw_isrc)}
    assert_equal 'US', isrc.country
    assert_equal 'PR3', isrc.registrant
    assert_equal '73', isrc.year
    assert_equal '00012', isrc.designation
  end

  def test_parse_lowercase_raw_isrc
    isrc = nil
    assert_nothing_raised {isrc = Model::ISRC.parse(@valid_raw_isrc.downcase)}
    assert_equal 'US', isrc.country
    assert_equal 'PR3', isrc.registrant
    assert_equal '73', isrc.year
    assert_equal '00012', isrc.designation
  end

  def test_parse_valid_printable_isrc
    isrc = nil
    assert_nothing_raised {isrc = Model::ISRC.parse(@valid_printable_isrc)}
    assert_equal 'US', isrc.country
    assert_equal 'PR3', isrc.registrant
    assert_equal '73', isrc.year
    assert_equal '00012', isrc.designation
  end
  
  def test_parse_invalid_isrc
    @invalid_isrcs.each do |isrc|
      assert_raise(Model::InvalidISRCError) { Model::ISRC.parse(isrc) }
    end
  end
  
  def test_isrc_to_readable_string
    isrc = Model::ISRC.parse(@valid_raw_isrc)
    assert_equal @valid_printable_isrc, isrc.to_s
    isrc = Model::ISRC.parse(@valid_raw_isrc.downcase)
    assert_equal @valid_printable_isrc, isrc.to_s
    isrc = Model::ISRC.parse(@valid_printable_isrc.downcase)
    assert_equal @valid_printable_isrc, isrc.to_s
  end
  
  def test_isrc_to_string
    isrc = Model::ISRC.parse(@valid_raw_isrc)
    assert_equal @valid_raw_isrc, isrc.to_str
    isrc = Model::ISRC.parse(@valid_raw_isrc.downcase)
    assert_equal @valid_raw_isrc, isrc.to_str
    isrc = Model::ISRC.parse(@valid_printable_isrc.downcase)
    assert_equal @valid_raw_isrc, isrc.to_str
  end
  
  def test_isrc_equality
    isrc1 = Model::ISRC.parse(@valid_raw_isrc)
    isrc2 = Model::ISRC.parse(@valid_printable_isrc)
    assert_equal isrc1, isrc2
    assert_equal isrc1, @valid_raw_isrc
    assert_equal isrc2, @valid_raw_isrc
    assert_equal isrc1, @valid_printable_isrc
    assert_equal isrc2, @valid_printable_isrc
  end
  
end

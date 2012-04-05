# -*- coding: utf-8 -*-
# $Id: test_utils.rb 288 2009-08-04 12:50:09Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the methods in the Utils module.
class TestUtils < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_country_names
    assert_equal 'Germany', Utils.get_country_name('DE')
    assert_equal nil, Utils.get_country_name('UNKNOWN')
  end
  
  def test_language_names
    assert_equal 'English', Utils.get_language_name('ENG')
    assert_equal nil, Utils.get_language_name('UNKNOWN')
  end
  
  def test_script_names
    assert_equal 'Cyrillic', Utils.get_script_name('Cyrl')
    assert_equal nil, Utils.get_script_name('UNKNOWN')
  end
  
  def test_release_type_names
    assert_equal 'Bootleg', Utils.get_release_type_name(Model::Release::TYPE_BOOTLEG)
    assert_equal nil, Utils.get_release_type_name('UNKNOWN')
  end
  
  def test_add_default_namespace
    name = 'Group'
    name_with_ns = Model::NS_MMD_1 + name
    assert_equal name_with_ns, Utils.add_namespace(name)
    assert_equal name_with_ns, Utils.add_namespace(name_with_ns)
  end

  def test_add_custom_namespace
    namespace = 'http://test.musicbrainz.org/ns/mmd-1.0#'
    name = 'Group'
    name_with_ns = namespace + name
    assert_equal name_with_ns, Utils.add_namespace(name, namespace)
    assert_equal name_with_ns, Utils.add_namespace(name_with_ns, namespace)
  end

  def test_remove_default_namespace
    name = 'Group'
    name_with_ns = Model::NS_MMD_1 + name
    assert_equal name, Utils.remove_namespace(name_with_ns)
    assert_equal name, Utils.remove_namespace(name)
  end

  def test_remove_custom_namespace
    namespace = 'http://test.musicbrainz.org/ns/mmd-1.0#'
    name = 'Group'
    name_with_ns = namespace + name
    assert_equal name, Utils.remove_namespace(name_with_ns, namespace)
    assert_equal name, Utils.remove_namespace(name, namespace)
  end
  
  def test_entity_type_to_string
    entity_type_symbol = Model::ReleaseGroup::ENTITY_TYPE
    entity_type_string = 'release-group'
    result = Utils.entity_type_to_string(entity_type_symbol)
    assert_equal entity_type_string, result
    assert result.is_a?(String), "Result is not a string."
  end
  
  def test_entity_type_to_symbol
    entity_type_symbol = Model::ReleaseGroup::ENTITY_TYPE
    entity_type_string = 'release-group'
    result = Utils.entity_type_to_symbol(entity_type_string)
    assert_equal entity_type_symbol, result
    assert result.is_a?(Symbol), "Result is not a symbol."
  end
  
  def test_check_options_with_valid_options
    given_options = { :query => '', :offset => 2, :name => 'Test', :limit => 1 }
    assert_nothing_raised { Utils.check_options given_options, :limit, :offset, :query, :name }
    assert_nothing_raised { Utils.check_options given_options, :limit, :offset, :query, :name, :extra_option }
  end

  def test_check_options_with_invalid_options
    given_options = { :limit => 1, :offset => 2, :bad_option => '', :name => 'Test' }
    assert_raise(ArgumentError) { Utils.check_options given_options, :limit, :offset, :query, :name }
  end

end

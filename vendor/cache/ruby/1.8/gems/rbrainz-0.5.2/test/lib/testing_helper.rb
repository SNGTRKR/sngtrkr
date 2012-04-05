# -*- coding: utf-8 -*-
# $Id: testing_helper.rb 254 2009-05-13 20:04:36Z phw $
#
# Usefull helper methods which are used in different test classes.
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

# Converts a query string into a hash.
def query_string_to_hash query_string
  Hash[*query_string.scan(/(.+?)=(.*?)(?:&|$)/).flatten].each_value {|v|
    v.gsub!('+', ' ')
    v.gsub!(/%([0-9a-f]{2})/i) { [$1.hex].pack 'C' }
  }
end

# True, if parent_class is one of the parent classes of child_class
def assert_inherited_from child_class, parent_class, message=nil
    result = false
    klass = child_class
    while not klass.nil?
      if klass == parent_class
        result = true
        break
      end
      klass = klass.superclass
    end
    assert(result, message)
end

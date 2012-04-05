# -*- coding: utf-8 -*-
# $Id: helper.rb 288 2009-08-04 12:50:09Z phw $
#
# Author::    Nigel Graham, Philipp Wolfer
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Utils
  
    class << self
    
      # Remove the given _namespace_ from _str_. Will return _str_ with the
      # namespace removed. If the namespace was not present in _str_ it will
      # be returned unchanged.
      def remove_namespace(str, namespace=Model::NS_MMD_1)
        if str =~ /^#{namespace}(.*)/
          return $1 
        else
          return str
        end
      end
      
      # Will return the given _str_ extended by _namespace_. If _str_ already
      # includes the namespace or if _str_ is empty it will be returned unchanged.
      def add_namespace(str, namespace=Model::NS_MMD_1)
        unless str =~ /^#{namespace}/ or str.to_s.empty?
          return namespace + str.to_s
        else
          return str
        end
      end
      
      # Converts an entity type constant symbol into the proper string representation 
      def entity_type_to_string(entity_type)
        return entity_type.to_s.sub('_', '-')
      end
      
      # Converts an entity type string into the proper symbol
      def entity_type_to_symbol(entity_type)
        unless entity_type.respond_to? :to_sym
          return entity_type
        end
        entity_type = entity_type.to_sym
        return entity_type.to_s.sub('-', '_').to_sym
      end
      
      # Check an options hash for required options.
      # Raises an ArgumentError if unknown options are present in the hash.
      def check_options(options, *optdecl)   # :nodoc:
        h = options.dup
        optdecl.each do |name|
          h.delete name
        end
        raise ArgumentError, "no such option: #{h.keys.join(' ')}" unless h.empty?
      end
    
    end
      
  end
end

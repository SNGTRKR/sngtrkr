require 'net/http'

class AdminTools

  # For reprocessing Paperclip images, when certain styles are missing.
  # Had to do it myself because their rake seems to crash for unknown reasons.
  # This also has the advantage of checking if the file exists rather than just assuming all don't.
  # We assume if the large image is missing, we need to reprocess this item.
  # AdminTools.reprocess_missing_images Release
  # AdminTools.reprocess_missing_images Artist
  def self.reprocess_missing_images klass
    klass.find_each do |inst|
      rep = false
      puts "START #{inst.id}"
      unless inst.image.present?
        next
      end
      large_image = inst.image(:large)
      begin
        actual = open(large_image)
      rescue
        rep = true
      end
      if actual.is_a?(StringIO) or !rep
        puts "SKIP #{inst.id}"
        next
      end

      puts "REPROCESS #{inst.id}"

      begin
        inst.image.reprocess!
      rescue
        inst.image.destroy
      end
    end
  end

end
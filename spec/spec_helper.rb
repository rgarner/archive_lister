require 'archive_lister'

def content_filename(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end
FILES = %w(lib/core_refinements lib/db_types lib/configuration lib/db_credentials lib/db_connection lib/database lib/version lib/model/model lib/model/class_methods lib/model/instance_methods).freeze

FILES.each do |file|
  require File.join(File.dirname(__FILE__), file)
end

require 'find'
require 'pathname'

property :target, String, name_property: true
property :source, String

action :copy do
  source = new_resource.source
  target = new_resource.target
  files = []
  Find.find(source) { |f| files.push(win_friendly_path(f)) }
  files.each do |file|
    if ::File.directory?(file)
      dir = win_friendly_path(::File.join(target, (Pathname.new(::File.path(file)).relative_path_from Pathname.new(source))))
      unless ::File.directory?(dir)
        converge_by "Making directory #{dir}..." do
          ::FileUtils.mkdir_p dir
        end
      end
    else
      source_item = ::File.directory?(source) ? (Pathname.new(::File.path(file)).relative_path_from Pathname.new(source)) : (Pathname.new(::File.path(file)).relative_path_from Pathname.new(::File.dirname(source)))
      target_path = win_friendly_path(::File.join(target, source_item))
      if file_checksum_match?(file, target_path)
        Chef::Log.debug("#{file} and #{target_path} checksums match, skipping...")
      else
        converge_by "Copying #{file} to #{target_path}..." do
          file_copy(file, target_path)
        end
      end
    end
  end
end

def win_friendly_path(path)
  path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\') if path
end

def file_copy(source, target)
  ::FileUtils.mkdir_p ::File.dirname(target) unless ::File.exist?(::File.dirname(target))
  ::FileUtils.cp source, target
end

def file_checksum_match?(source, target)
  if ::File.exist?(target)
    ::Digest::SHA256.file(source).hexdigest == ::Digest::SHA256.file(target).hexdigest
  end
end



# python_binaries.gemspec
Gem::Specification.new do |s|
  s.name        = 'python_binaries'
  s.version     = '0.0.1'
  s.summary     = 'Python script binaries for Ubuntu'
  s.files       = Dir['output/script_ubuntu_*.gz']
  s.executables << 'python_binary_extractor'
end


# python_binary_extractor
#!/usr/bin/env ruby

require 'rbconfig'
require 'zlib'

def architecture
  case RbConfig::CONFIG['host_cpu']
  when *%w[arm64 aarch64 arch64]
    'arm64'
  when 'x86_64'
    'amd64'
  else
    'i386'
  end
end

suffix = case RbConfig::CONFIG['host_os']
         when /linux/
           os = `. /etc/os-release 2> /dev/null && echo ${ID}_${VERSION_ID}`.strip
           os = 'ubuntu_20.04' if os.start_with?('ubuntu_20.')
           os = 'ubuntu_22.04' if os.start_with?('ubuntu_22.')
           os = 'ubuntu_24.04' if os.start_with?('ubuntu_24.')
           "#{os}_#{architecture}"
         else
           'unknown'
         end

binary = "#{__FILE__}_#{suffix}"

if File.exist?("#{binary}.gz") && !File.exist?(binary)
  File.open binary, 'wb', 0o755 do |file|
    Zlib::GzipReader.open("#{binary}.gz") { |gzip| file << gzip.read }
  end
end

unless File.exist? binary
  raise 'Invalid platform, must be running on Ubuntu 20.04/22.04/24.04.'
end

exec *$*.unshift(binary)

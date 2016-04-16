require "rake/clean"
require "open-uri"
require "erb"

VERSION = "2.3.6"
FILE_NAME = "BitTorrent-Sync_%s.tar.gz"
DL_URI = "https://download-cdn.getsync.com/#{VERSION}/linux-%s/#{FILE_NAME}"

class TemplateData
  attr_accessor :uris, :version

  def initialize
    @uris = []
    @version = VERSION
    @file_name = FILE_NAME
  end

  def get_binding
    binding
  end
end

template_data = TemplateData.new

task default: %w(checksums.txt make.sh qpkg.cfg)

directory "downloads"

%w(arm i386 x64).each do |arch|
  file_name = "downloads/BitTorrent-Sync_#{arch}.tar.gz"
  uri = DL_URI % [arch, arch]
  template_data.uris << uri

  file "checksums.txt" => file_name

  file file_name => "downloads" do |t|
    open(file_name, "wb") do |file|
      puts "Downloading #{uri}"
      open(uri) do |download|
        download.each_line { |line| file.write(line) }
      end
      puts "Done"
    end
  end
end

desc "Download BitTorrent Sync binaries and generate checksums.txt"
file "checksums.txt" do |t|
  puts "Generating checksums.txt"
  system "shasum -a 256 downloads/* > checksums.txt"
  puts "Done"
end

desc "Generate make.sh from template"
file "make.sh" => "templates/make.sh.erb" do |t|
  puts "Generating make.sh"

  erb = ERB.new(File.read("templates/make.sh.erb"), nil, "<>")
  IO.write("make.sh", erb.result(template_data.get_binding))
  File.chmod(0755, "make.sh")

  puts "Done"
end

desc "Generate qpkg.cfg from template"
file "qpkg.cfg" => "templates/qpkg.cfg.erb" do |t|
  puts "Generating qpkg.cfg"

  erb = ERB.new(File.read("templates/qpkg.cfg.erb"), nil, "<>")
  IO.write("qpkg.cfg", erb.result(template_data.get_binding))

  puts "Done"
end

CLEAN.include "downloads/"

CLOBBER.include %w(checksums.txt make.sh qpkg.cfg)

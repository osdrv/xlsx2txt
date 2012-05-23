#encoding: utf-8

require "fileutils"

class CSVFile

  attr_accessor :converted_file, :file_path, :file_ext, :file_name, :new_path

  def initialize( uploaded_file )
    self.file_path = uploaded_file[ :tempfile ].to_path
    self.file_ext = File.extname( uploaded_file[ :filename ] )
    self.file_name = File.basename( uploaded_file[ :filename ], file_ext )
    self.new_path = "#{file_path}#{file_ext}"
  end

  def convert!
    system( "cp #{file_path} #{new_path}" )
    xls = Roo::Spreadsheet.open( "#{new_path}" )
    self.converted_file = "#{@@folder_name}/#{file_name}.txt"
    xls.to_csv( converted_file )
  end

  def with_converted_file( open_mode = "r+", &blk )
    ( yield File.open( converted_file, open_mode ) ) if File.exists?( converted_file )
  end

  class << self

    def as_single_archive( files, basename, &blk )
      @@tmp_path = "#{Xlsx2txt::Application.root}/tmp/"
      @@folder_name = "#{@@tmp_path}/#{basename}"
      @@archive_name = "#{basename}.zip"
      Dir.mkdir( @@folder_name )

      if !files.nil? && files.any?
        files.each do |file|
          yield CSVFile.new( file )
        end
      end

      Dir.chdir( @@tmp_path )
      system "zip -q -1 -r #{@@archive_name} #{basename}"
      FileUtils.rm_rf @@folder_name
      File.new( @@archive_name )
    end

  end
end

#encoding: utf-8

require "fileutils"

class ConvertAction < Cramp::Action

  def respond_with
    files = request.params[ "original_file" ] rescue nil
    halt( 412, {}, "File name expected" ) if files.nil? || !files.any?
    @@basename = Time.now.to_i
    [ 200, {
      "Content-type" => "application/zip",
      "Content-Disposition" => "attachment;filename=#{@@basename}.zip"
    }]
  end

  def start
    files = request.params[ "original_file" ]
    tmp_path = "#{Xlsx2txt::Application.root}/tmp/"
    folder_name = "#{tmp_path}/#{@@basename}"
    archive_name = "#{@@basename}.zip"
    Dir.mkdir( folder_name )
    if !files.nil? && files.any?
      files.each do |file|
        file_path = file[ :tempfile ].to_path
        file_ext = File.extname( file[ :filename ] )
        file_name = File.basename( file[ :filename ], file_ext )
        new_path = "#{file_path}#{file_ext}"
        system( "cp #{file_path} #{new_path}" )
        xls = Roo::Spreadsheet.open( "#{new_path}" )
        xls.to_csv( "#{folder_name}/#{file_name}.txt" )
        f = File.open( "#{folder_name}/#{file_name}.txt", "r+" )
        data = f.read.gsub( /\"/, "" )
        f.truncate( 0 )
        f.pos = 0
        f.write( data )
        f.close
      end
      Dir.chdir( tmp_path )
      system "zip -q -1 -r #{archive_name} #{@@basename}"
      render File.open( archive_name ).read
      FileUtils.rm_rf folder_name
    end
    finish
  end

end

#encoding: utf-8

require "iconv"
require "time"

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
    archive_file = CSVFile.as_single_archive( files, @@basename ) do |csv_file|
      csv_file.convert!
      csv_file.with_converted_file do |f|
        data = f.read.gsub( /\"/, "" ).gsub(/\n/, "\r\n" )
        data.scan( /\d{4}\-\d{2}\-\d{2}/ ).each do |date|
          time = Time.parse( date )
          data = data.gsub( date, Russian.strftime( time, "%d %B %Y г." ) )
        end
        data = Iconv.conv( "UTF-16", "UTF-8", data )
        f.truncate( 0 )
        f.pos = 0
        f.write( data )
        f.close
      end
    end
    render archive_file.read

    finish
  end

end

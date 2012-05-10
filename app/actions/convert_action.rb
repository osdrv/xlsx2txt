class ConvertAction < Cramp::Action

  def respond_with
    filename = request.params[ "original_file" ][ :filename ] rescue nil
    halt( 412, {}, "File name expected" ) if filename.nil?
    basename = File.basename( filename, File.extname( filename ) )
    [ 200, {
      "Content-type" => "text/plain; charset=utf-8",
      "Content-Disposition" => "attachment;filename=#{basename}.txt"
    }]
  end

  def start
    file = request.params[ "original_file" ]
    if !file.nil?
      file_path = file[ :tempfile ].to_path
      file_ext = File.extname( file[ :filename ] )
      new_path = "#{file_path}#{file_ext}"
      system( "cp #{file_path} #{new_path}" )
      xls = Excelx.new( "#{new_path}" )
      @@csv_path = "#{file_path}.csv"
      xls.to_csv( @@csv_path )
      render File.open( @@csv_path ).read.gsub( "\"", "" )
    end
    finish
  end

end

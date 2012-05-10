class HomeAction < Cramp::Action
  @@template = Haml::Engine.new( File.read( Xlsx2txt::Application.root( 'app/views/index.haml' ) ) )
  def start
    render @@template.render
    finish
  end
end

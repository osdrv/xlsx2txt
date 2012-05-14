function bind_add_file() {
  document.querySelector( ".add_file" ).addEventListener( "click", function( event ) {
    event.preventDefault();
    var file = document.querySelector( "input[type=\"file\"]" );
    var parent = file.parentElement;
    parent.appendChild( document.createElement( "br" ) );
    parent.appendChild( file.cloneNode() );
  }, false );
}

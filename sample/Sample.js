let _ = require( 'whttp' );

/**/

var got = _.http.retrieve
( {
  uri : 'https://www.google.com/',
  sync : 1,
  attemptLimit : 2,
} );

console.log( got.response.body.substring( 0, 60 ) + '...' );

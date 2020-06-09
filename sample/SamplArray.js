let _ = require( 'whttp' );

/**/

let uris = [];
for( let i = 0; i < 100; i++ )
uris.push( 'https://www.google.com/' );

let got = _.http.retrieve
( {
  uri : uris,
  sync : 1,
  attemptLimit : 5
} );

console.log( got[ 25 ].response.body.substring( 0, 60 ) + '... \n', got[ 75 ].response.body.substring( 0, 60 ) + '...' );


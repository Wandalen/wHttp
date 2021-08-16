const _ = require( 'whttp' );

/* */

const uris = [];
for( let i = 0; i < 100; i++ )
uris.push( 'https://www.google.com/' );

let got = _.http.retrieve
({
  uri : uris,
  attemptLimit : 5
})
.then( ( op ) =>
{
  console.log( op[ 25 ].response.body.substring( 0, 60 ) + '...' );
  console.log( op[ 75 ].response.body.substring( 0, 60 ) + '...' );
  return null;
});


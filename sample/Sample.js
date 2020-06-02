
let _ = require( 'whttp' );

/**/

var got = _.http.retrieve
( {
  uri : 'https://www.google.com/',
  sync : 1,
  attemptLimit : 2,
} );
console.log( got.response.body.substring( 0, 60 ) + '...' );

/* */

var uris = [];
var results = [];
const l = 100;
for( let i = 0; i < l; i++ )
{
  uris.push( 'https://www.google.com/' );
  results.push( '<!doctype html><html itemscope="" itemtype="http://schema.or...' )
}

var hooksArr = _.http.retrieve
( {
  uri : uris,
  sync : 1,
  attemptLimit : 3,
  verbosity : 0,
} );
var got = [];
for( let i = 0; i < hooksArr.length; i++ )
got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

console.log( got );

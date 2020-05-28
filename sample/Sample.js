
let _ = require( 'whttp' );

/**/

let got = _.http.retrieve
({
  'google.com',
  sync : 1,
  attemptLimit : 3,
});
console.log( got );


const _ = require( 'whttp' );

/* */

return _.http.retrieve
({
  uri : 'https://www.google.com/',
  attemptLimit : 2,
})
.then( ( op ) =>
{
  console.log( op.response.body.substring( 0, 60 ) + '...' );
  return null;
});


( function _Http_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../dwtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../l1/http/Include.s' );
}

//

var _ = _global_.wTools;

// --
// context
// --

// --
// tests
// --

function retrieve( test )
{
  test.case = 'single URI';
  var got = _.http.retrieve
  ( {
    uri : 'https://github.com/Wandalen/wModuleForTesting1a/blob/master/.gitattributes',
    sync : 1,
    attemptLimit : 1,
  } );
  test.notIdentical( got.response.body.match( /<tr>/g ), null );

  /* */

  test.case = 'array of URI';
  var uris = [
    'https://github.com/Wandalen/wModuleForTesting1/blob/master/proto/dwtools/testing/l1/Include.s',
    'https://github.com/Wandalen/wModuleForTesting1/blob/master/proto/dwtools/testing/l1/ModuleForTesting1.s'
  ];
  var got = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 2
  } );
  test.notIdentical( got[ 0 ].response.body.match( /<tr>/g ), null );
  test.notIdentical( got[ 1 ].response.body.match( /<tr>/g ), null );

  /* */

  test.case = 'array of URI, order of answers is the same as requests';
  var uris = [
    'https://github.com/Wandalen/wModuleForTesting1/blob/master/proto/dwtools/testing/l1/Include.s',
    'https://github.com/Wandalen/wModuleForTesting1/blob/master/proto/dwtools/testing/l1/ModuleForTesting1.s'
  ];
  var got0 = _.http.retrieve( { uri : uris[ 0 ], sync : 1, attemptLimit : 1 } );
  var got1 = _.http.retrieve( { uri : uris[ 1 ], sync : 1, attemptLimit : 1 } );
  var got = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 2
  } );
  test.identical( got[ 0 ].response.body.match( /<tr>/g ), got0.response.body.match( /<tr>/g ) );
  test.identical( got[ 1 ].response.body.match( /<tr>/g ), got1.response.body.match( /<tr>/g ) );
}
retrieve.description =
`
Makes GET requests to the given URI
`

//

function retrieveConcurrentLimitOption( test )
{
  test.case = 'concurrentLimit === 0';
  var uri = 'https://www.google.com/';
  test.shouldThrowErrorSync( () =>
  {
    _.http.retrieve
    ( {
      uri,
      sync : 1,
      concurrentLimit : 0
    } );
  } )

  /* */

  test.case = 'concurrentLimit < 0';
  var uri = 'https://www.google.com/';
  test.shouldThrowErrorSync( () =>
  {
    _.http.retrieve
    ( {
      uri,
      sync : 1,
      concurrentLimit : -1
    } );
  } )

  /* */

  test.case = 'concurrentLimit < uris';
  var uris = [ 'https://www.google.com/', 'https://www.google.com/' ];
  var got = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 2,
    concurrentLimit : 1
  } );
  test.identical( got.length, 2 );

  /* */

  test.case = 'concurrentLimit > uris';
  var uris = [ 'https://www.google.com/', 'https://www.google.com/' ];
  var got = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 2,
    concurrentLimit : 3
  } );
  test.identical( got.length, 2 );
}
retrieveConcurrentLimitOption.description = `
Makes no more GET requests at the same time than specified in the concurrentLimit option
`

//

function retrieveStress( test )
{
  var uris = [];
  const l = 1e6;
  for( let i = 0; i < l; i++ )
  uris.push( 'https://www.google.com/' );

  var got = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : l,
    concurrentLimit : l
  } );

  test.identical( got.length, l );
}
retrieveStress.rapidity = -1;

// --
// declare
// --

var Proto =
{

  name : 'Tools.mid.NpmTools',
  silencing : 1,
  routineTimeOut : 60000,

  context :
  {
    provider : null,
    suitePath : null,
  },

  tests :
  {
    retrieve,
    retrieveConcurrentLimitOption,

    retrieveStress,
  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();

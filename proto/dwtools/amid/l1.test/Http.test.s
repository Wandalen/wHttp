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
// rapidity : -2 !!!!!!!!!!!!!!!!!!!!!!!!
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
      attemptLimit : 3,
      verbosity : 3,
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
      attemptLimit : 3,
      verbosity : 3,
      concurrentLimit : -5
    } );
  } )

  /* */

  test.case = 'concurrentLimit < uris';
  var uris = [];
  var results = [];
  var l = 100;
  for( let i = 0; i < l; i++ )
  {
    uris.push( 'https://www.google.com/' );
    results.push( '<!doctype html><html itemscope="" itemtype="http://schema.or...' );
  }

  var hooksArr = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 3,
    verbosity : 3,
    concurrentLimit : 5
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

  var exp = results;
  test.identical( got, exp );

  /* */

  test.case = 'concurrentLimit > uris';
  var uris = [];
  var results = [];
  var l = 100;
  for( let i = 0; i < l; i++ )
  {
    uris.push( 'https://www.google.com/' );
    results.push( '<!doctype html><html itemscope="" itemtype="http://schema.or...' );
  }

  var hooksArr = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 3,
    verbosity : 3,
    concurrentLimit : 150
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

  var exp = results;
  test.identical( got, exp );

}
retrieveConcurrentLimitOption.description = `
Makes no more GET requests at the same time than specified in the concurrentLimit option
`

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
    retrieveConcurrentLimitOption
  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();

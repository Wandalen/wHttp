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
    uri : 'https://www.google.com/',
    sync : 1,
    attemptLimit : 1,
  } );
  var exp = '<!doctype html><html itemscope="" itemtype="http://schema.or...';
  test.identical( got.response.body.substring( 0, 60 ) + '...', exp );

  //

  test.case = 'array of identical URI';
  var uris = [];
  var results = [];
  var l = 100;
  for( let i = 0; i < l; i++ )
  {
    uris.push( 'https://www.google.com/' );
    results.push( '<!doctype html><html itemscope="" itemtype="http://schema.or...' )
  }

  var hooksArr = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 3
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

  var exp = results;
  test.identical( got, exp );

  //

  test.case = 'array of different URI';
  var uris = [];
  var results = [];
  var l = 50;
  for( let i = 0; i < l; i++ )
  {
    uris.push( 'https://www.google.com/' );
    results.push( '<!doctype html><html itemscope="" itemtype="http://schema.or...' )
    uris.push( 'https://www.npmjs.com/' );
    results.push( '<!doctype html...' )
  }

  var hooksArr = _.http.retrieve
  ( {
    uri : uris,
    sync : 1,
    attemptLimit : 3
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  {
    if( i % 2 === 0 )
    got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';
    else
    got[ i ] = hooksArr[ i ].response.body.substring( 1, 15 ) + '...';
  }

  var exp = results;
  test.identical( got, exp );
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
      attemptLimit : 3,
      verbosity : 3,
      concurrentLimit : 0
    } );
  } )

  //

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

  //

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

  //

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

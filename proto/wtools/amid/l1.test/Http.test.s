( function _Http_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  require( '../l1/http/Include.s' );
}

//

const _ = _global_.wTools;

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

  test.case = 'array of URI';
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
    attemptLimit : 3
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

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
  test.case = 'concurrentLimit 10 time less than uris';
  var uris = [];
  var results = [];
  const l = 100;
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
    concurrentLimit : 10
  } );
  var got = [];
  for( let i = 0; i < hooksArr.length; i++ )
  got[ i ] = hooksArr[ i ].response.body.substring( 0, 60 ) + '...';

  var exp = results;
  test.identical( got, exp );
}
retrieveConcurrentLimitOption.description =
`
Makes no more GET requests at the same time than specified in the concurrentLimit option
`;

//

function retrieveWithOptionOnSucces( test )
{
  test.case = 'onSuccess returns true';
  var got = _.http.retrieve
  ({
    uri : 'https://www.google.com/',
    sync : 1,
    attemptLimit : 3,
    onSuccess : ( res ) => true,
    verbosity : 3,
  });
  test.true( _.map.is( got ) );
  test.identical( got.uri, 'https://www.google.com/' );
  test.le( got.attempt, 3 );
  test.true( _.consequenceIs( got.ready ) );
  test.identical( got.err, null );
  test.true( _.object.is( got.response ) );
  test.identical( got.response.statusCode, 200 );

  test.case = 'onSuccess returns false, should throw error';
  var onErrorCallback = ( err, arg ) =>
  {
    test.true( _.error.is( err ) );
    test.identical( arg, undefined );
    test.true( _.strHas( err.originalMessage, 'Attempts is exhausted, made 3 attempts' ) );
  };
  test.shouldThrowErrorSync( () =>
  {
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      sync : 1,
      attemptLimit : 3,
      onSuccess : ( res ) => false,
      verbosity : 3,
    });
  }, onErrorCallback );
}

//

function retrieveWithOptionAttemptDelayMultiplier( test )
{
  test.case = 'onSuccess returns false, should throw error';
  var start = _.time.now();
  var onErrorCallback = ( err, arg ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 3250 );
    test.true( _.error.is( err ) );
    test.identical( arg, undefined );
    test.true( _.strHas( err.originalMessage, 'Attempts is exhausted, made 4 attempts' ) );
  };
  test.shouldThrowErrorSync( () =>
  {
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      sync : 1,
      attemptLimit : 4,
      attemptDelay : 250,
      attemptDelayMultiplier : 3,
      onSuccess : ( res ) => false,
      verbosity : 3,
    });
  }, onErrorCallback );
}

//

function retrieveCheckAttemptOptionsSupplementing( test )
{
  test.case = 'attemptLimit in options map, onSuccess returns false, should throw error';
  var start = _.time.now();
  var onErrorCallback = ( err, arg ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 200 );
    test.true( _.error.is( err ) );
    test.identical( arg, undefined );
    test.true( _.strHas( err.originalMessage, 'Attempts is exhausted, made 4 attempts' ) );
  };
  test.shouldThrowErrorSync( () =>
  {
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      sync : 1,
      attemptLimit : 4,
      onSuccess : ( res ) => false,
      verbosity : 3,
    });
  }, onErrorCallback );

  /* */

  test.case = 'without attempts settings in options map, onSuccess returns false, should throw error';
  var start = _.time.now();
  var onErrorCallback = ( err, arg ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 200 );
    test.true( _.error.is( err ) );
    test.identical( arg, undefined );
    test.true( _.strHas( err.originalMessage, 'Attempts is exhausted, made 3 attempts' ) );
  };
  test.shouldThrowErrorSync( () =>
  {
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      sync : 1,
      onSuccess : ( res ) => false,
      verbosity : 3,
    });
  }, onErrorCallback );
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.mid.Http',
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
    retrieveWithOptionOnSucces,
    retrieveWithOptionAttemptDelayMultiplier,
    retrieveCheckAttemptOptionsSupplementing,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();

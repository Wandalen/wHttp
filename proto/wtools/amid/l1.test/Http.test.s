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
// tests
// --

function retrieve( test )
{
  const a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'single URI';
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      attemptLimit : 1,
    });
  });
  a.ready.then( ( op ) =>
  {
    var exp = '<!doctype html><html itemscope="" itemtype="http://schema.or...';
    test.identical( op.response.body.substring( 0, 60 ) + '...', exp );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'array of URIs';
    var uris = _.array.make( 100 );
    for( let i = 0; i < uris.length; i++ )
    uris[ i ] = 'https://www.google.com/';

    return _.http.retrieve
    ({
      uri : uris,
      attemptLimit : 3
    });
  });
  a.ready.then( ( op ) =>
  {
    var got = _.array.make( op.length );
    for( let i = 0; i < op.length; i++ )
    got[ i ] = op[ i ].response.body.substring( 0, 60 ) + '...';

    var exp = _.array.make( 100 );
    for( let i = 0 ; i < exp.length ; i++ )
    exp[ i ] = '<!doctype html><html itemscope="" itemtype="http://schema.or...';

    test.identical( got, exp );
    return null;
  });

  /* - */

  return a.ready;
}
retrieve.description =
`
Makes GET requests to the given URI
`;

//

function retrieveConcurrentLimitOption( test )
{
  const a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'concurrentLimit 10 time less than uris';
    var uris = _.array.make( 100 );
    for( let i = 0; i < uris.length; i++ )
    uris[ i ] = 'https://www.google.com/';

    return _.http.retrieve
    ({
      uri : uris,
      attemptLimit : 3,
      verbosity : 3,
      concurrentLimit : 10
    });
  });
  a.ready.then( ( op ) =>
  {
    var got = _.array.make( op.length );
    for( let i = 0; i < op.length; i++ )
    got[ i ] = op[ i ].response.body.substring( 0, 60 ) + '...';

    var exp = _.array.make( 100 );
    for( let i = 0 ; i < exp.length ; i++ )
    exp[ i ] = '<!doctype html><html itemscope="" itemtype="http://schema.or...';

    test.identical( got, exp );
    return null;
  });

  /* - */

  return a.ready;
}
retrieveConcurrentLimitOption.description =
`
Makes no more GET requests at the same time than specified in the concurrentLimit option
`;

//

function retrieveWithOptionOnSucces( test )
{
  const a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {

    test.case = 'onSuccess returns true';
    return _.http.retrieve
    ({
      uri : 'https://www.google.com/',
      attemptLimit : 3,
      onSuccess : ( res ) => true,
      verbosity : 3,
    });
  });
  a.ready.then( ( op ) =>
  {
    test.true( _.map.is( op ) );
    test.identical( op.uri, 'https://www.google.com/' );
    test.le( op.attempt, 3 );
    test.true( _.consequenceIs( op.ready ) );
    test.identical( op.err, null );
    test.true( _.object.is( op.response ) );
    test.identical( op.response.statusCode, 200 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'onSuccess returns false, should throw error';
    var onErrorCallback = ( err, arg ) =>
    {
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      test.true( _.strHas( err.originalMessage, 'Attempts exhausted, made 3 attempts' ) );
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.http.retrieve
      ({
        uri : 'https://www.google.com/',
        attemptLimit : 3,
        onSuccess : ( res ) => false,
        verbosity : 3,
      });
    }, onErrorCallback );
  });

  /* - */

  return a.ready;
}

//

function retrieveWithOptionAttemptDelayMultiplier( test )
{
  const a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'onSuccess returns false, should throw error';
    var start = _.time.now();
    var onErrorCallback = ( err, arg ) =>
    {
      var spent = _.time.now() - start;
      test.ge( spent, 3250 );
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      test.true( _.strHas( err.originalMessage, 'Attempts exhausted, made 4 attempts' ) );
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.http.retrieve
      ({
        uri : 'https://www.google.com/',
        attemptLimit : 4,
        attemptDelay : 250,
        attemptDelayMultiplier : 3,
        onSuccess : ( res ) => false,
        verbosity : 3,
      });
    }, onErrorCallback );
  });

  /* - */

  return a.ready;
}

//

function retrieveCheckAttemptOptionsSupplementing( test )
{
  const a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'attemptLimit in options map, onSuccess returns false, should throw error';
    var start = _.time.now();
    var onErrorCallback = ( err, arg ) =>
    {
      var spent = _.time.now() - start;
      test.ge( spent, 200 );
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      test.true( _.strHas( err.originalMessage, 'Attempts exhausted, made 4 attempts' ) );
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.http.retrieve
      ({
        uri : 'https://www.google.com/',
        attemptLimit : 4,
        onSuccess : ( res ) => false,
        verbosity : 3,
      });
    }, onErrorCallback );
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'without attempts settings in options map, onSuccess returns false, should throw error';
    var start = _.time.now();
    var onErrorCallback = ( err, arg ) =>
    {
      var spent = _.time.now() - start;
      test.ge( spent, 200 );
      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
      test.true( _.strHas( err.originalMessage, 'Attempts exhausted, made 3 attempts' ) );
    };
    return test.shouldThrowErrorAsync( () =>
    {
      return _.http.retrieve
      ({
        uri : 'https://www.google.com/',
        onSuccess : ( res ) => false,
        verbosity : 3,
      });
    }, onErrorCallback );
  });

  /* - */

  return a.ready;
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

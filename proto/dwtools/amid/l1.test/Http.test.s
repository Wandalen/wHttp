( function _Http_test_ss_( ) {

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

// function onSuiteBegin( test )
// {
//   let context = this;
//   context.provider = _.fileProvider;
//   let path = context.provider.path;
//   context.suitePath = context.provider.path.pathDirTempOpen( path.join( __dirname, '../..'  ),'NpmTools' );
//   context.suitePath = context.provider.pathResolveLinkFull({ filePath : context.suitePath, resolvingSoftLink : 1 });
//   context.suitePath = context.suitePath.absolutePath;
// }

//

// function onSuiteEnd( test )
// {
//   let context = this;
//   let path = context.provider.path;
//   _.assert( _.strHas( context.suitePath, 'NpmTools' ), context.suitePath );
//   path.pathDirTempClose( context.suitePath );
// }

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
    attemptLimit : 3,
    verbosity : 3,
    concurrentLimit : 50
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

function retrieveConcurrentLimitOption()
{

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

  // onSuiteBegin,
  // onSuiteEnd,

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

})();

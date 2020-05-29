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
    test.case = 'test one';
    var got = 1;
    var exp = 1;
    test.identical( got, exp );
  }
  
  
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
      retrieve
    },
  
  }
  
  //
  
  var Self = new wTestSuite( Proto );
  if( typeof module !== 'undefined' && !module.parent )
  wTester.test( Self.name );
  
  })();
  
  
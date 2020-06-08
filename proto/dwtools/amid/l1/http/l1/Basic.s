( function _Basic_s_()
{

'use strict';

let needle = require( 'needle' );
let _ = _global_.wTools;
let Self = _.http = _.http || Object.create( null );

// --
// inter
// --

function retrieve( o )
{
  let ops = [];
  // let ready = new _.Consequence().take( null );
  let ready = new _.Consequence();
  let opened = 0;
  let closed = 0;

  if( !_.mapIs( o ) )
  o = { uri : o }
  _.routineOptions( retrieve, o );

  if( o.successStatus === null )
  o.successStatus = [ 200 ];
  else
  o.successStatus = _.arrayAs( o.successStatus );

  let isSingle = !_.arrayIs( o.uri );
  o.uri = _.arrayAs( o.uri );

  if( o.openTimeOut === null )
  o.openTimeOut = o.individualTimeOut;
  if( o.responseTimeOut === null )
  o.responseTimeOut = o.individualTimeOut;
  if( o.readTimeOut === null )
  o.readTimeOut = o.individualTimeOut;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strsAreAll( o.uri ), 'Expects only strings as a package name' );
  _.assert( o.attemptLimit > 0 );
  _.assert( o.attemptDelay >= 0 );
  _.assert( o.openTimeOut >= 0 );
  _.assert( o.responseTimeOut >= 0 );
  _.assert( o.readTimeOut >= 0 );
  _.assert( o.individualTimeOut >= 0 );
  _.assert( o.concurrentLimit >= 1 );

  /* code before concurrentLimit implementation*/
  // for( let i = 0; i < o.uri.length; i++ )
  // ready.also( () => _request( { uri : o.uri[ i ], attempt : 0, index : i } ) );

  // ready.then( ( result ) =>
  // {
  //   /* remove heading null */
  //   result.splice( 0, 1 )
  //   if( isSingle )
  //   return result[ 0 ];
  //   return result;
  // } );
  /* code before concurrentLimit implementation*/

  /* concurrentLimit implementation code start */
  let counter = 0;
  let totalRequests = o.uri.length;
  let answers = [];
  let firstLimite = o.uri.slice( 0, o.concurrentLimit );
  let i;
  for( i = 0; i < firstLimite.length; i++ )
  _request( { uri : firstLimite[ i ], attempt : 0, index : i } );
  /* concurrentLimit implementation code end */

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function retry( op )
  {
    op.attempt += 1;
    delete op.err;
    _.time.begin( o.attemptDelay, () => _request( op ) );
  }

  /* */

  function _request( op )
  {

    // if( !op.ready )
    // op.ready = new _.Consequence();

    if( op.attempt === 0 )
    opened += 1;

    if( op.attempt >= o.attemptLimit )
    {
      ready.take( null )
      throw _.err( `Failed to retrieve ${op.uri}, made ${op.attempt} attemptLimit` );
    }

    ops[ op.index ] = op;
    if( o.verbosity >= 3 )
    console.log( ` . Attempt ${op.attempt} to retrieve ${op.index} ${op.uri}..` );

    let o2 =
    {
      open_timeout : o.openTimeOut,
      response_timeout : o.responseTimeOut,
      read_timeout : o.readTimeOut,
    }

    needle.get( op.uri, o2, function( err, response )
    {
      op.err = err;
      op.response = response;
      if( err )
      return retry( op );
      if( !_.longHas( o.successStatus, op.response.statusCode ) )
      return retry( op );
      if( o.onSuccess && !o.onSuccess( op ) )
      return retry( op );
      handleEnd( op );
    } );

    // return op.ready;
  }

  /* */

  function returnAnswers( op )
  {
    counter += 1;
    answers[ op.index ] = op;
    if( counter === totalRequests )
    isSingle ? ready.take( op ) : ready.take( answers )
  }

  function handleEnd( op )
  {
    closed += 1;
    if( o.verbosity >= 3 )
    console.log( ` + Retrieved ${op.index} ${closed} / ${opened} ${op.uri}.` );

    // concurrentLimit code start
    if( i < o.uri.length )
    {
      _request( { uri : o.uri[ i ], attempt : 0, index : i } )
      i += 1;
    }
    // concurrentLimit code end

    // op.ready.take( op );
    returnAnswers( op )
  }

}

retrieve.defaults = /* qqq : cover */
{
  uri : null,
  verbosity : 0,
  successStatus : null,
  sync : 0,
  onSuccess : null,
  attemptLimit : 3,
  attemptDelay : 100,
  openTimeOut : null,
  responseTimeOut : null,
  readTimeOut : null,
  individualTimeOut : 10000,
  concurrentLimit : 256, /* qqq : implement and cover option concurrentLimit */
}

// --
// declare
// --

let Extend =
{

  protocols : [ 'http', 'https' ],

  retrieve,

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();

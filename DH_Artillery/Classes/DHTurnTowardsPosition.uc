//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHTurnTowardsPosition extends DHMoveState;

var float TurnRadius;
var float TurnSpeed;
var float bIsTurningRight;
var vector PositionGoal;

function Tick(float DeltaTime)
{
    TurnPlane(true, 1000, Airplane.CurrentSpeed, DeltaTime);
    Log("tick");
}

DefaultProperties
{

}

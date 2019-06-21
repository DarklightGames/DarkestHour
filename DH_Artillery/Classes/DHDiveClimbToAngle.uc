//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//------------------------------------------------------------------------------
// Dives or climbs the plane until it is faceing the desired angle. Angle is
// relative to the horizontal heading of the plane (it's velocity without the
// Z component).
//------------------------------------------------------------------------------
class DHDiveClimbToAngle extends DHMoveState;

var float TurnRadius;       // Radius of circular turn.
var float TurnSpeed;        // Desired Speed of turn.
var bool bIsClimbing;   // Is this a right turn?
var float DesiredAngle; // Goal angle to turn to.

function Tick(float DeltaTime)
{
    DiveOrClimbPlane(bIsClimbing, TurnRadius, Airplane.CurrentSpeed, DeltaTime);


    if (TotalTurned >= DesiredAngle)
    {
        Log("TurnToAngleDone: "$TotalTurned$", "$DesiredAngle);
        Airplane.OnMoveEnd();
    }

}

DefaultProperties
{

}

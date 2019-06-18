//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Turns the plane until it's velocity points at the PositionGoal. Useful for
// aligning the plane with a target.
// The GOAL is to be aligned with the PositionGoal.
//-----------------------------------------------------------
class DHTurnTowardsPosition extends DHMoveState;

var float TurnRadius;       // Radius of circular turn.
var float TurnSpeed;        // Desired Speed of turn.
var bool bIsTurningRight;   // Is this a right turn?
var vector PositionGoal;    // When the plane's velocity is aligned with this position, end the turn.
var bool bIsInitialized;    // keeps track if the initialization has been automatically preformed.
var vector TurnEndPoint;    // Point in world space that the plane should be at when the turn ends.

function Tick(float DeltaTime)
{
    local vector TangentVelocity;

    // Find the Turn End Point. This also sets the TangentAngle, so that we can detect the turn end.
    if (!bIsInitialized)
    {
        TurnEndPoint = CalculateTurnEndPoint(PositionGoal, Airplane.Velocity, Airplane.Location, bIsTurningRight, TurnRadius);
        bIsInitialized = true;
    }

    TurnPlane(bIsTurningRight, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    TangentVelocity = Normal(PositionGoal - TurnEndPoint);
    TangentVelocity.Z = 0;
    TangentVelocity = Normal(TangentVelocity);

    // Test if the TurnEndPoint has been passed. If so, set to proper endpoint and end the turn.
    if(TotalTurned >= TangentAngle)
    {
        TurnEndPoint.Z = Airplane.Location.Z;
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.OnMoveEnd(); // tell Airplane that move is done.
    }
}

DefaultProperties
{

}

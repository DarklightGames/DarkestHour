//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Dives/Climbs the plane until it's velocity points at the PositionGoal.
// The GOAL is to be aligned with the PositionGoal.
// For lack of a better term, I keep using the term "Turn".
//-----------------------------------------------------------


class DHDiveClimbTowardsPosition extends DHMoveState;

var float TurnRadius;       // Radius of circular turn.
var float TurnSpeed;        // Desired Speed of turn.
var bool bIsClimbing;   // Is this a right turn?
var vector PositionGoal;    // When the plane's velocity is aligned with this position, end the movement.
var bool bIsInitialized;    // keeps track if the initialization has been automatically preformed.
var vector TurnEndPoint;    // Point in world space that the plane should be at when the turn ends.

function Tick(float DeltaTime)
{
    local vector TangentVelocity;

    // Find the Turn End Point. This also sets the TangentAngle, so that we can detect the turn end.
    if (!bIsInitialized)
    {
        TurnEndPoint = CalculateDiveClimbEndPoint(PositionGoal, Airplane.Velocity, Airplane.Location, bIsClimbing, TurnRadius);
        bIsInitialized = true;
    }

    DiveOrClimbPlane(bIsClimbing, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    TangentVelocity = Normal(PositionGoal - TurnEndPoint);
    //TangentVelocity.Y = 0;
    //TangentVelocity = Normal(TangentVelocity);

    // Test if the TurnEndPoint has been passed. If so, set to proper endpoint and end the turn.
    if(TotalTurned >= TangentAngle)
    {
        Log("Done: "$TotalTurned);
        //TurnEndPoint.Y = Airplane.Location.Y;
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.OnMoveEnd(); // tell Airplane that move is done.
    }
}

DefaultProperties
{

}

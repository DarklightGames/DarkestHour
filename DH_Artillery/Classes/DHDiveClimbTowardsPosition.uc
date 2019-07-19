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

var float TurnRadius;           // Radius of circular turn.
var float TurnSpeed;            // Desired Speed of turn.
var bool bIsClimbing;           // Is this a right turn?
var vector PositionGoal;        // When the plane's velocity is aligned with this position, end the movement.
var bool bIsInitialized;        // keeps track if the initialization has been automatically preformed.
var vector TurnEndPoint;        // Point in world space that the plane should be at when the turn ends.
var float DesiredSpeedClimb;    // Desired speed when climbing. Should be slower than standard speed.
var float DesiredSpeedDive;     // Desired speed when diving. Should be faster than standard.

function UpdateSpeed(float DeltaTime)
{
        //Decide which speed change to use
        if (bIsClimbing)
        {
            DesiredSpeed = DesiredSpeedClimb;
        }
        else
        {
            DesiredSpeed = DesiredSpeedDive;
        }

        super.UpdateSpeed(DeltaTime);
}

function Tick(float DeltaTime)
{
    local vector TangentVelocity;

    // Find the Turn End Point. This also sets the TangentAngle, so that we can detect the turn end.
    if (!bIsInitialized)
    {
        TurnEndPoint = CalculateDiveClimbEndPoint(PositionGoal, Normal(Airplane.Velocity), Airplane.Location, bIsClimbing, TurnRadius);
        bIsInitialized = true;
    }

    UpdateSpeed(DeltaTime);

    DiveOrClimbPlane(bIsClimbing, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    TangentVelocity = Normal(PositionGoal - TurnEndPoint);

    // Test if the TurnEndPoint has been passed. If so, set to proper endpoint and end the turn.
    if(TotalTurned >= TangentAngle)
    {
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.OnMoveEnd(); // tell Airplane that move is done.
    }
}

DefaultProperties
{

}

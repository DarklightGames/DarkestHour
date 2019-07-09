//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//------------------------------------------------------------------------------
// Dives or climbs the plane until it is faceing the desired angle. Angle is
// relative to the horizontal heading of the plane (it's velocity without the
// Z component).
// Negative angle points downwards (dive), positive angle points upwards (climb)
//------------------------------------------------------------------------------
class DHDiveClimbToAngle extends DHDiveClimbTowardsPosition;

var float TurnRadius;       // Radius of circular turn.
var float TurnSpeed;        // Desired Speed of turn.
var bool bIsClimbing;   // Is this a right turn?
var float DesiredAngleWorld; // Goal angle to turn to, in plane space. SET THIS.
var float TurnAmount; // Amount of angle we want to turn. Do not set this.
var bool bIsInitialized; // Has this movestate been initialized yet?

function Tick(float DeltaTime)
{
    local vector Heading;
    local float PlaneAngle;

    // Calculate offset
    if (!bIsInitialized)
    {
        // Get angle between the flat heading and the desired angle.
        Heading.X = Airplane.Velocity.X;
        Heading.Y = Airplane.Velocity.Y;
        Heading.Z = 0;

        PlaneAngle = ACos(Normal(Airplane.Velocity) Dot Normal(Heading));

        // If plane is traveling down then make sure it's angle is negative.
        if(Airplane.Velocity.Z < 0)
            PlaneAngle *= -1;

        //Compare DesiredAngleWorld to the world angle.
        TurnAmount = DesiredAngleWorld - PlaneAngle;

        //Log(DesiredAngle$", "$DesiredAngleWorld);

        if (TurnAmount > 0)
        {
            bIsClimbing = true;
        }
        else if (TurnAmount < 0)
        {
            bIsClimbing = false;
        }
        else
        {
            Airplane.OnMoveEnd();
        }

        TurnAmount = Abs(TurnAmount);

        bIsInitialized = true;
    }

    UpdateSpeed(DeltaTime);

    DiveOrClimbPlane(bIsClimbing, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    if (TotalTurned >= TurnAmount)
    {
        Log("TurnToAngleDone: "$TotalTurned);
        Airplane.OnMoveEnd();
    }

}

DefaultProperties
{

}

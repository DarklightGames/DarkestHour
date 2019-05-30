 //==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Defines Movement information, specifications, helper functions.
// The code to actually preform movements is done here.
// Extend this class for each goal driven movement.
//-----------------------------------------------------------
class DHMoveState extends Object abstract;

enum ETurnDirection
{
    TURN_UP,
    TURN_DOWN,
    TURN_RIGHT,
    TURN_LEFT
};

// Owning airplane. Movements are done on this actor.
var DHAirplane Airplane;

function bool HasMetGoal();

function Tick(float DeltaTime);

// Many moveStates use circular Rotation. Use this calculation across all of them.
function vector CalculateRotationPosition(ETurnDirection TurnDirection, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local float ArcDistance;
    local vector PlaneSpaceNewPosition;
    local vector WorldSpaceNewPosition;

    ArcDistance = Speed * DeltaTime;

    DeltaAngle = ArcDistance / TurnRadius;

    // Relative to the rotation center.
    PlaneSpaceNewPosition.X = Sin(DeltaAngle) * TurnRadius;
    PlaneSpaceNewPosition.Y = Cos(DeltaAngle) * TurnRadius;
    PlaneSpaceNewPosition.Z = 0;

    // Make relative to the plane's position.
    if (TurnDirection == TURN_RIGHT)
    {
        PlaneSpaceNewPosition.Y = TurnRadius - PlaneSpaceNewPosition.Y;
    }
    else if (TurnDirection == TURN_LEFT)
    {
        PlaneSpaceNewPosition.Y = PlaneSpaceNewPosition.Y - TurnRadius;
    }

    // Convert to world positon
    WorldSpaceNewPosition = (PlaneSpaceNewPosition >> Airplane.Rotation) + Airplane.Location;

    return WorldSpaceNewPosition;
}

DefaultProperties
{

}

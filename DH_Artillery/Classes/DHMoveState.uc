 //==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Defines Movement information, specifications, helper functions.
// The code to actually preform movements is done here.
// Extend this class for each goal driven movement.
//
// Movement States differ in their goals, not their implementation of the movement.
//-----------------------------------------------------------
class DHMoveState extends Object abstract;

enum ETurnDirection
{
    TURN_UP,
    TURN_DOWN,
    TURN_RIGHT,
    TURN_LEFT
};

var float TotalTurned;

// Owning airplane. Movements are done on this actor.
var DHAirplane Airplane;

function bool HasMetGoal();

function Tick(float DeltaTime);

function bool DiveOrClimbPlane()
{
}

function bool TurnPlane(bool bIsTurnRight, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local rotator DeltaRot;
    local float ArcDistance;
    local vector NewPlanePosition;

    // Properly Update Velocity.
    ArcDistance = Speed * DeltaTime;
    DeltaAngle = ArcDistance / TurnRadius;

    // Calculate position
    NewPlanePosition = CalculateRotationPosition(Airplane.Location, Airplane.Velocity, bIsTurnRight, TurnRadius, Speed, DeltaTime);

    DeltaRot.Roll = 0;
    if(bIsTurnRight)
        //DeltaRot.Yaw = -1 * class'UUnits'.static.RadiansToUnreal(-DeltaAngle);
        DeltaRot.Yaw =class'UUnits'.static.RadiansToUnreal(DeltaAngle);
    else
        //DeltaRot.Yaw = -1 * class'UUnits'.static.RadiansToUnreal(DeltaAngle);
        DeltaRot.Yaw = class'UUnits'.static.RadiansToUnreal(-DeltaAngle);
    DeltaRot.Pitch = 0;

    TotalTurned += Abs(DeltaAngle);

    Airplane.Velocity = Airplane.Velocity >> DeltaRot;
    Airplane.SetLocation(NewPlanePosition);

    // Roll plane for banking turns. 0 -> 100 100 ->0. Banking angle realtive to max turn radius. Plane quality.

    // Decide if terminating condition true, rotate plane to that heading and return true.
    return true;
}


// Many moveStates use circular Rotation. Use this calculation across all of them.
// TODO: Add in axes variations for the circule, allowing for the creation of elipsoids. This would allow for percise curved movement to any position.
function vector CalculateRotationPosition(vector CurrentLocation, vector CurrentVelocity, bool bIsClockwise, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local float ArcDistance;
    local vector PlaneSpaceNewPosition;
    local vector WorldSpaceNewPosition;
    local rotator Heading;

    ArcDistance = Speed * DeltaTime;

    DeltaAngle = ArcDistance / TurnRadius;

    // Relative to the rotation center.
    PlaneSpaceNewPosition.X = Sin(DeltaAngle) * TurnRadius;
    PlaneSpaceNewPosition.Y = Cos(DeltaAngle) * TurnRadius;
    PlaneSpaceNewPosition.Z = 0;

    // Make relative to the plane's position.
    if (bIsClockwise)
    {
        // A turn to thr right.
        PlaneSpaceNewPosition.Y = TurnRadius - PlaneSpaceNewPosition.Y;
    }
    else if (!bIsClockwise)
    {
        PlaneSpaceNewPosition.Y = PlaneSpaceNewPosition.Y - TurnRadius;
    }

    Heading = OrthoRotation(CurrentVelocity, CurrentVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = 0;

    // Convert to world positon
    WorldSpaceNewPosition = (PlaneSpaceNewPosition >> Heading) + CurrentLocation;



    return WorldSpaceNewPosition;
}


DefaultProperties
{

}

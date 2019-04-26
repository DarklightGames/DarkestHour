//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
// TODO:
// [ ] Airplanes should be "destructible" in that they can be damaged to a point
// of inoperability. If they are damaged before their payload is released, they
// will not drop bombs or fire guns, will have smoke and flames from their
// propellers, and will not perform subsequent passes. When this happens, an
// obvious explosion and sound should indicate that this has happened.
//==============================================================================

/*
Structure wise, there will be two main states. The first is the state driving the AI.
This is the core dicision making for searching for targets, approaching targets.
Essentially this drives the placement of waypoints.

The second main state is the various movement states. Straightline, turning,
making an attack run.
*/


class DHAirplane extends Actor
    abstract;

var localized string    AirplaneName;
var float               MaxSpeed;
var float               MinSpeed;
var float               CurrentSpeed;
var float               MinTurningRadius; // tightest/smallest circular path this plane can turn on.

struct Waypoint
{
    var vector position;
    var float radius;
};

var Waypoint            CurrentWaypoint; // Current waypoint we are traveling to.
var array<Waypoint>     WaypointQueue;

simulated function PostBeginPlay()
{
    CurrentSpeed = class'DHUnits'.static.MetersToUnreal(MaxSpeed);
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{

    //Fist Process waypoint status.

    WaypointUpdate();
    MovementUpdate(DeltaTime);
}

simulated function WaypointUpdate(float DeltaTime)
{
    //Check if there is not current waypoint set.
    if(CurrentWaypoint == none)
    {
        Waypoint
    }
}

// Sets a new current waypoint.
simulated function SetCurrentWaypoint(Waypoint NewWaypoint)
{
    CurrentWaypoint = NewWaypoint;
}

// update position based on current position, velocity, and current waypoint.
simulated function MovementUpdate(float DeltaTime)
{
    local rotator Heading;

    // Move along curve to waypoint.
    velocity = Normal(Vect(1,1,0)) * CurrentSpeed * DeltaTime;



    // Make sure plane is always faceing the direction it is traveling.
    Heading.Pitch = 0;
    Heading.Roll = 0;
    Heading.Yaw = Acos( Normal(Vect(1,0,0)) dot Normal(velocity) ) * 10430.378350470452724949566316381;
    SetRotation(Heading);
}

// Given A position, and a desired "OnTargetDistance", create a paht of waypoints.
// The "OnTargetDistance" is the minimum distance away from the path end postion the plane should be
// when it stops turning.
function PathFind(vector PathEndPosition, float OnTargetDistance)
{
}

// called whenever the plane passes it's current waypoint.
function OnWaypointPassed()
{
}


function vector CalculateRotationPosition(bool bIsRightTurn, vector Forward, vector Position, float TurnRadius, float Speed, float DeltaTime)
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
    if(bIsRightTurn)
    {
        PlaneSpaceNewPosition.Y = TurnRadius - PlaneSpaceNewPosition.Y;
    }
    else
    {
        PlaneSpaceNewPosition.Y = PlaneSpaceNewPosition.Y - TurnRadius;
    }

    // Convert to world positon

    return WorldSpaceNewPosition;
}

defaultproperties
{
    AirplaneName="Airplane"
    DrawType=DT_Mesh
    bAlwaysRelevant=true
    bReplicateMovement = true
    bCanBeDamaged=true
    Physics = PHYS_Flying
    //bRotateToDesired = true;
    //Rotation

    MaxSpeed = 400;
    MinSpeed = 10;
    CurrentSpeed = 0;
}

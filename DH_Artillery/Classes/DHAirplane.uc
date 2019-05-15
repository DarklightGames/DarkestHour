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
var float               MinTurningRadius; // Tightest/smallest circular path this plane can turn on.
var float               HeadingTolerance; // Margin of error for plane facing a certain direction.

enum EMovementState
{
    MOVE_Straight,
    MOVE_RightTurn,
    MOVE_LeftTurn
};

var EMovementState MovementState;

enum EAIState
{
    AI_Entrance,
    AI_Searching,
    AI_Approaching,
    AI_Attacking,
    AI_Exiting
};

var EAIState AIState;

struct Waypoint
{
    var vector Position;
    var float Radius;       // How close to position you reguarding this as a met checkpoint.
};

var Waypoint            CurrentWaypoint; // Current waypoint we are traveling to.

simulated function PostBeginPlay()
{
    CurrentSpeed = class'DHUnits'.static.MetersToUnreal(MaxSpeed);
    GotoState('Entrance');
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{

    //Fist Process waypoint status.

    TickAI(DeltaTime);
    MovementUpdate(DeltaTime);
}

function TickAI(float DeltaTime){}
function OnWaypointReached() {}
function OnTurnEnd() {}

state Entrance
{
    function TickAI(float DeltaTime)
    {

    }

    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        AIState = AI_Entrance;
        MovementState = MOVE_Straight;
        SetTimer(3,false);
    }

    function EndState(){}
}

state Searching
{
    simulated function Timer()
    {
        GotoState('Approaching');
    }

    function BeginState()
    {
        AIState = AI_Searching;
        MovementState = MOVE_Straight;
        SetTimer(1, false);
    }
}

state Approaching
{
    function TickAI(float DeltaTime)
    {
        /*
        local vector X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        if ( 1.0 - (Normal(X) dot Normal(Y)) <  HeadingTolerance)
        {
            Log("Facing Target, continuing straight");
            MovementState = MOVE_Straight;
        }
        */
    }

    function OnTurnEnd()
    {
        Log("Facing Target, continuing straight");
        MovementState = MOVE_Straight;
    }

    function OnWaypointReached()
    {
        Log("Waypoint Reached");
        GotoState('Attacking');
    }

    function BeginState()
    {
        AIState = AI_Approaching;
        MovementState = MOVE_RightTurn;

        // Create a random waypoint.
        CurrentWaypoint.Position.X = Rand(800);
        CurrentWaypoint.Position.Y = Rand(800);
        CurrentWaypoint.Position.Z = Rand(800);
        CurrentWaypoint.Radius = 1.0;
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


        // Check if waypoint met.
    if (VSize(CurrentWaypoint.Position - Location) <= CurrentWaypoint.Radius)
    {
        OnWaypointReached();
    }

    if (MovementState == MOVE_RightTurn)
    {
        velocity = Normal(CurrentWaypoint.Position - Location) *  CurrentSpeed;

        if ( 1.0 - (Normal(velocity) dot Normal(CurrentWaypoint.Position - Location)) <  HeadingTolerance)
        {
            OnTurnEnd();
        }
    }
    else if (MovementState == MOVE_RightTurn)
    {
        velocity = Normal(CurrentWaypoint.Position - Location) *  CurrentSpeed;

        if ( 1.0 - (Normal(velocity) dot Normal(CurrentWaypoint.Position - Location)) <  HeadingTolerance)
        {
            OnTurnEnd();
        }
    }
    else if (MovementState == MOVE_Straight)
    {
        // Do nothing?
    }



    // Make sure plane is always faceing the direction it is traveling.
    Heading.Pitch = 0;
    Heading.Roll = 0;
    Heading.Yaw = Acos( Normal(Vect(1,0,0)) dot Normal(velocity) ) * 10430.378350470452724949566316381;
    SetRotation(Heading);
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
    //bReplicateMovement = true
    bCanBeDamaged=true
    Physics = PHYS_Flying
    //bRotateToDesired = true;
    //Rotation
    HeadingTolerance = 0.01;
    MaxSpeed = 400;
    MinSpeed = 10;
    CurrentSpeed = 0;
}

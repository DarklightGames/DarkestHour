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
var vector              DesiredLocation;



/* All movement states should have a goal, and a OnEnd event. The OnEnd event
tells the statemachine to move to the next state. For an attack, It could be defined
by starting a dive-towards-position move, callback event, fire, Level-Out-To-elevation
*/
/*
enum EMovementState
{
    MOVE_Straight,  // Continue straight along current velocity path.
    MOVE_ToLocation,    // Changes current velocity to point at DesiredLocation. Calls OnReachDesiredLocation when it reaches the location.
    MOVE_TurnTowardsPosition // Turns until facing goal. Once facing, calls OnMoveEnd
};

var EMovementState MovementState;
*/

var DHMoveState MoveState;

enum EAIState
{
    AI_Entrance,
    AI_Searching,
    AI_Approaching,
    AI_Attacking,
    AI_Exiting
};

var EAIState AIState;

/* Represents a Attack Target that needs to be approached. */
struct Target
{
    var vector Position;
    var float Radius;       // How far from target to be before starting attack run. Must be facing the target by this distance.
    // TODO: var AttackType // Type of attack run to be carried out on this target.
};

var Target            CurrentTarget; // Current waypoint we are traveling to.

// Debug
var vector            StartLocation;
var Target            Target1;
var Target            Target2;
var Target            Target3;
var Target            Target4;
var int               TargetCount;



simulated function PostBeginPlay()
{
    CurrentSpeed = 800;
    /*
    local int box;
    box = 2500;

    StartLocation = Location;
    Waypoint1.Radius = 10;
    Waypoint1.Position = StartLocation;
    Waypoint1.Position.X +=  box;
    DrawDebugSphere(Waypoint1.Position, 200, 10, 255,0,255);
    DrawStayingDebugLine(Waypoint1.Position, Waypoint1.Position + vect(0, 0, 2000), 255,0,255);

    Waypoint2.Radius = 10;
    Waypoint2.Position = StartLocation;
    Waypoint2.Position.X += box;
    Waypoint2.Position.Y += box;
    DrawDebugSphere(Waypoint2.Position, 200, 10, 255,0,255);
    DrawStayingDebugLine(Waypoint2.Position, Waypoint2.Position + vect(0, 0, 2000), 255,0,255);

    Waypoint3.Radius = 10;
    Waypoint3.Position = StartLocation;
    Waypoint3.Position.Y += box;
    DrawDebugSphere(Waypoint2.Position, 200, 10, 255,0,255);
    DrawStayingDebugLine(Waypoint3.Position, Waypoint3.Position + vect(0, 0, 2000), 255,0,255);

    Waypoint4.Radius = 10;
    Waypoint4.Position = StartLocation;
    DrawDebugSphere(Waypoint4.Position, 200, 10, 255,0,255);
    DrawStayingDebugLine(Waypoint4.Position, Waypoint4.Position + vect(0, 0, 2000), 255,0,255);
    */
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
    /*
    DrawDebugSphere(Waypoint1.Position, 200, 10, 255,0,255);
    DrawDebugSphere(Waypoint2.Position, 200, 10, 255,0,255);
    DrawDebugSphere(Waypoint3.Position, 200, 10, 255,0,255);
    DrawDebugSphere(Waypoint4.Position, 200, 10, 255,0,255);
    */

    TickAI(DeltaTime);
    MovementUpdate(DeltaTime);
}

// Tick function for state machines.
function TickAI(float DeltaTime){}

// Event for when the approach to the target has been finished.
function OnTargetReached() {}

// Called when a Movement has reached it's predefined goal. Overridden by states.
function OnMoveEnd() {}

function PickTarget()
{
        // Create a random waypoint.
        /*
        CurrentWaypoint.Position.X = StartLocation.X + Rand(1000);
        CurrentWaypoint.Position.Y = StartLocation.Y + Rand(1000);
        CurrentWaypoint.Position.Z = Location.Z;
        */

        /*
        WaypointCount++;

        switch (WaypointCount % 4)
        {
            case 0:
                Log("1");
                CurrentWaypoint = Waypoint1;
                break;
            case 1:
                Log("2");
                CurrentWaypoint = Waypoint2;
                break;
            case 2:
                Log("3");
                CurrentWaypoint = Waypoint3;
                break;
            case 3:
                Log("4");
                CurrentWaypoint = Waypoint4;
                break;
        }
        */

        /*
        CurrentWaypoint.Radius = 10;
        Log("AT: "$V3ToV2(Location)$" TO: "$V3ToV2(CurrentWaypoint.Position));
        */
}

auto simulated state Entrance
{
    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        Log("Entrance State");

        AIState = AI_Entrance;
        //MovementState = MOVE_Straight;
        BeginStraight(vect(1,0,0));

        SetTimer(0.1, false);
    }
}

simulated state Searching
{
    simulated function Timer()
    {
        PickTarget();
        GotoState('Approaching');
    }

    function BeginState()
    {
        Log("Searching");
        AIState = AI_Searching;
        BeginStraight(vect(1,0,0));
        SetTimer(0.1, false);
    }
}

simulated state Approaching
{
    function OnTurnEnd()
    {
        Log("Facing Target, continuing straight");
        //MovementState = MOVE_Straight;
    }

    function OnWaypointReached()
    {
        Log("Waypoint Reached: "$Location);
        GotoState('Attacking');
    }

    function BeginState()
    {
        Log("Approaching");
        AIState = AI_Approaching;
        //MovementState = MOVE_RightTurn;
    }

}

simulated state Attacking
{
    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        Log("Attacking");
        AIState = AI_Attacking;
        //MovementState = MOVE_Straight;
        SetTimer(0.1, false);
    }
}

// Sets a new current waypoint.
simulated function SetCurrentTarget(Target NewTarget)
{
    CurrentTarget = NewTarget;
}

// update position based on current position, velocity, and current waypoint.
simulated function MovementUpdate(float DeltaTime)
{
    local rotator Heading;

    MoveState.Tick(DeltaTime);

    // Make sure plane is always facing the direction it is traveling.
    Heading = OrthoRotation(velocity, velocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = 0;
    SetRotation(Heading);

    // Check if waypoint met. Restrain from continued movement until new waypoint is set.
    if (VSize(V3ToV2(CurrentTarget.Position - Location)) <= CurrentTarget.Radius)
    {
        OnTargetReached();
    }
}

// MovementState related functions
function BeginTurnTowardsPosition(vector TurnPositionGoal, bool bIsTurnRight)
{

}

function BeginStraight(vector Direction)
{
    local DHStraight StraightState;

    StraightState = new class'DHStraight';
    //DHStraight(MoveStright).Direction = Normal(Direction);
    StraightState.Direction = Normal(Direction);
    StraightState.Airplane = self;
    MoveState = StraightState;
}

// Converts 3d vector into 2d vector.
static function vector V3ToV2(vector InVector)
{
    local vector OutVector;

    OutVector.X = InVector.X;
    OutVector.Y = InVector.Y;
    OutVector.Z = 0;

    return OutVector;
}

defaultproperties
{
    AirplaneName="Airplane"
    AIState = AI_Entrance;
    DrawType=DT_Mesh
    bAlwaysRelevant=true
    bReplicateMovement = true
    bCanBeDamaged=true
    Physics = PHYS_Flying

    HeadingTolerance = 0.01;
    MaxSpeed = 10;
    MinSpeed = 10;
    CurrentSpeed = 0;
}

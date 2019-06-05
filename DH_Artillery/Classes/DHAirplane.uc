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
    //CurrentTarget.Position = Location + vect(-100,0,0);
    CurrentTarget.Position = Location;
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
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
    //CurrentTarget.Position = Location + vect(-2000, -2000, 0);
    //CurrentTarget.Position = Location + vect(-1000, 2000, 0);
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

        BeginStraight(vect(0,-1,0));

        SetTimer(4, false);
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
        //BeginStraight(vect(1,0,0));
        SetTimer(0.1, false);
    }
}

simulated state Approaching
{
    function OnMoveEnd()
    {
        BeginStraight(Velocity);
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
        BeginTurnTowardsPosition(CurrentTarget.Position, 1000, false);
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
function BeginTurnTowardsPosition(vector TurnPositionGoal, float TurnRadius, bool bIsTurnRight)
{
    local DHTurnTowardsPosition TurnTowardsState;
    local vector VelocityPre;

    TurnTowardsState = new class'DHTurnTowardsPosition';
    TurnTowardsState.Airplane = self;
    TurnTowardsState.TurnRadius = TurnRadius;
    TurnTowardsState.bIsTurningRight = bIsTurnRight;
    TurnTowardsState.PositionGoal = CurrentTarget.Position;

    MoveState = TurnTowardsState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_None);
    Velocity = VelocityPre;
}

function BeginStraight(vector Direction)
{
    local DHStraight StraightState;
    local vector VelocityPre;

    StraightState = new class'DHStraight';
    StraightState.Direction = Normal(Direction);
    StraightState.Airplane = self;
    MoveState = StraightState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_Flying);
    Velocity = VelocityPre;
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

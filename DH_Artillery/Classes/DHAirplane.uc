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

// STRUCTURE
// Airplanes run through a simple state cycle: Searching->Approaching->Attacking.
// This cycle is repeated until the plane is shot down, or decides to leave.
//
// Searching: Picking target.
// Approaching: Position plane to be ready to preform Attack.
// Attacking: Preform attack run.
//
// The Airplane seeks to find, approach, and attack the Target. The current
// target is represented by the CurrentTarget variable.
//
// DHAirplane is supported by the class DHMoveState. DHMoveState objects move
// the Airplane, telling the plane when the move is done via the OnMoveEnd()
// event. The current move state determines what kind of move is done. The
// current move state object is stored in the MoveState variable. ALL direct
// movement of the plane should occur in a MoveState object, NOT in Airplane
// itself. Create a new child of DHMoveState if you want a new movement pattern.
//
// Essentially you control the movement of the plane by setting MoveState.
// Function exist to set MoveState, such as BeginTurnTowardsPosition() and
// BeginStraight().

class DHAirplane extends Actor
    abstract;

var localized string    AirplaneName;

// Current Speed of the aircraft. Used in move state calculations. Set this, not the the velocity to effect move speed changes.
var float               CurrentSpeed;

// The current MoveState. What this variable is set to determines the movement pattern the plane preforms.
var DHMoveState MoveState;

// Represents an Attack Target that needs to be approached and attacked.
struct Target
{
    var vector Position;
    var float Radius;       // How far from target to be before starting attack run. Must be facing the target by this distance.
    // TODO: var AttackType // Type of attack run to be carried out on this target, after it has been approached.
};

var Target  CurrentTarget; // Current target.

simulated function PostBeginPlay()
{
    CurrentSpeed = 800;
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
    TickAI(DeltaTime);
    MovementUpdate(DeltaTime);
}

// Tick function for the individual states.
function TickAI(float DeltaTime){}

// Event for when the approach to the target has been finished.
function OnTargetReached() {}

// Called when a Movement has reached it's predefined goal. Overridden by states.
function OnMoveEnd() {}

// This function is used by the Searching state to decide which target is next.
// CurrentTarget should be set here.
function PickTarget()
{
    CurrentTarget.Position = Location + vect(-2000, -2000, 0);
}

// Initial State. The plane enters into the combat area.
auto simulated state Entrance
{
    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        Log("Entrance State");
        BeginStraight(vect(1,0,0));
        SetTimer(4, false);
    }
}

// This step simulates the plane looking for a new target to attack. When the state ends, a target is picked.
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
        SetTimer(0.1, false);
    }
}

// Positions the airplane to be ready to preform the attack run. Typcally ends
// when plane has reached the proper distance to the target to begin the run.
state Approaching
{
    function OnMoveEnd()
    {
        BeginStraight(Velocity);
    }

    function BeginState()
    {
        Log("Approaching");
        BeginTurnTowardsPosition(CurrentTarget.Position, 1000, false);
    }
}

// Preform attack Run on the target.
simulated state Attacking
{
    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        Log("Attacking");
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

// This function begins a turn that stops when the plane is aligned with TurnPositionGoal.
// It sets MoveState.
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

// This begins the straight movement state. The plane will move in Direction
// forever.
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
    DrawType=DT_Mesh
    bAlwaysRelevant=true
    bReplicateMovement = true
    bCanBeDamaged=true
    Physics = PHYS_Flying

    CurrentSpeed = 0;
}

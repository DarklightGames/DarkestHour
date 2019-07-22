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
// Functions exist to set MoveState, such as BeginTurnTowardsPosition() and
// BeginStraight().

class DHAirplane extends Actor
    abstract;

var localized string    AirplaneName;

// Current Speed of the aircraft. Used in move state calculations. Set this, not the the velocity to effect move speed changes.
var float               CurrentSpeed;

// Bank roll values for when turning
var float               MaxBankAngle;
var float               BankRate;
var float               BankAngle;

// Turn speed control
var float               TurnSpeed; // desired turn speed
var float               TurnAcceleration; // Rate of velocity change to TurnSpeed.
var float               MinTurnRadius;

// Straight speed control - MoveStates should not reference these directly, they should be passed as parameters.
var float               StandardSpeed; // Desired speed for straight movement.
var float               ApproachingSpeed; // Desired speed for straight movement when approuching a target to attack, This will be the starting speed durring the attack run.
var float               StraightAcceleration; // Plane acceleration for straight movement;

var float               DiveClimbRadius;   // Turn radius of the dive and climb.
var float               DivingSpeed;      // When diving the plane, this is the top speed. Makes the dive attacks look more beliveable.
var float               DivingAcceleration;

var float               ClimbingSpeed;      // Desired speed to use when climbing.

var float               CruisingHeight;     // This is the hight of the plane when flying normally. The hight it starts attack runs from and returns to.

// The current MoveState. What this variable is set to determines the movement pattern the plane preforms.
var DHMoveState         MoveState;

// Represents an Attack Target that needs to be approached and attacked.
struct Target
{
    var vector Position;
    var float Radius;       // How far from target to be before starting attack run. Must be facing the target by this distance.
    var float MinimumHeight; // Minimum height above the target before pulling up when dive attacking. This is the bottom of the
    // TODO: var AttackType // Type of attack run to be carried out on this target, after it has been approached.
};

var Target          CurrentTarget; // Current target.

var bool            bIsPullingUp;
var bool            bIsLevelingOut;
var bool            bIsTurningTowardsTarget;

// Guns, Cannons, and bombs
var float               AutoCannonRPM;    // Rounds per minute for auto cannon.
var float               AutoCannonTime;   // Time since last shot.
var class<Projectile>   AutoCannonProjectileClass;
var bool                bIsShootingAutoCannon;
var float               AutoCannonSpread;

var vector              AutoCannonFireOffset;

// Debug---
//var int pick;

/*
var bool DebugPrintOnClient;

replication
{
    reliable if (bNetInitial || bNetDirty)
        DebugPrintOnClient;
}
*/

simulated function PostBeginPlay()
{
    CurrentSpeed = StandardSpeed;
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
    if (Role == ROLE_Authority)
    {
        TickAI(DeltaTime);
        MovementUpdate(DeltaTime);
        //Log(VSize(Velocity));
        TickAIPostMove(DeltaTime);
    }
    else
    {
        //Log("NOT OWNED");
        //Log(Physics$"/t"$VSize(Velocity));
    }

}

// Tick function for the individual states.
function TickAI(float DeltaTime){}

// Tick function for the states after MovementUpdate has completed.
function TickAIPostMove(float DeltaTime){}

// Event for when the approach to the target has been finished.
function OnTargetReached() {}

// Called when a Movement has reached it's predefined goal. Overridden by states.
function OnMoveEnd() {}

// This function is used by the Searching state to decide which target is next.
// CurrentTarget should be set here.
function PickTarget()
{

    local int pick;
    pick = Rand(100);
    /*
    if (pick % 3 == 0)
    {
        CurrentTarget.Position = vect(21543, -39272, -1040);
    }
    else if (pick % 3 == 1)
    {
        CurrentTarget.Position = vect(-14667, -21146, -1040);
    }
    else if (pick % 3 == 2)
    {
        CurrentTarget.Position = vect(-2596, -27184, -1040);
    }
    */



    //CurrentTarget.Position = Location - vect(0, 3000, 0);
    CurrentTarget.Position = vect(21543, -39272, -1040);
    CurrentTarget.Radius = 13000;
    //CurrentTarget.Radius = 10;
    CurrentTarget.MinimumHeight = 2200;
}

// Initial State. The plane enters into the combat area.
auto state Entrance
{
    simulated function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {
        BeginStraight(vect(-1,0,0), StandardSpeed, StraightAcceleration);
        SetTimer(1, false);
    }
}

// This step simulates the plane looking for a new target to attack. When the state ends, a target is picked.
state Searching
{
    simulated function Timer()
    {
        PickTarget();
        GotoState('Approaching');
    }

    function BeginState()
    {
        Log("Searching");
        BeginStraight(Normal(velocity), StandardSpeed, StraightAcceleration);
        SetTimer(0.1, false);
    }
}

// Positions the airplane to be ready to preform the attack run. Typcally ends
// when plane has reached the proper distance to the target to begin the run.
state Approaching
{
    function OnTargetReached()
    {
        if(bIsTurningTowardsTarget)
        {
            //Log("Attack bank: "$BankAngle);
            GotoState('DiveAttacking');
        }
    }

    function OnMoveEnd()
    {
        BeginStraight(Velocity, StandardSpeed, StraightAcceleration);
    }

    function TickAI(float DeltaTime)
    {
        local rotator HeadingRotator;
        local vector TargetInPlaneSpace;
        local bool bIsTurningRight;
        local vector TurnCriclePosition;
        local vector PlaneLocalTurnCriclePosition;

        // Decide to turn left or right towards target.
        HeadingRotator = OrthoRotation(Velocity, Velocity Cross vect(0, 0, 1), vect(0, 0, 1));
        HeadingRotator.Roll = 0;

        TargetInPlaneSpace = (CurrentTarget.Position - Location) << HeadingRotator;

        // If the planeSpace target location has a positive Y value, turn right.
        if (TargetInPlaneSpace.Y >= 0)
        {
            bIsTurningRight = true;
        }
        // Otherwise, if the target location in planespace is negative, turn left.
        else
        {
            bIsTurningRight = false;
        }

        // Only start turning is the turn circle and the target radius circle do
        // not overlap. This makes sure the plane will have enough room to finish
        // it's turn before hitting the target attack start radius.
        // Check now to see if we can turn immediately, or check after velocity
        // has been updated to ensure FPS independant logic.

        if (bIsTurningRight)
        {
            //TurnCriclePosition = MinTurnRadius >> HeadingRotator * (Normal(Velocity) Cross vect(0,0,1)) + Location;
            //TurnCriclePosition = (MinTurnRadius) >> HeadingRotator + Location;
            PlaneLocalTurnCriclePosition.Y = MinTurnRadius;

        }
        else
        {
            //TurnCriclePosition = (-1 * MinTurnRadius) >> HeadingRotator + Location;
            PlaneLocalTurnCriclePosition.Y = -1 * MinTurnRadius;
        }

        TurnCriclePosition = (PlaneLocalTurnCriclePosition >> HeadingRotator) + Location;
        TurnCriclePosition.Z = 0;

        if (!bIsTurningTowardsTarget && VSize( V3ToV2(TurnCriclePosition - CurrentTarget.Position) ) > (CurrentTarget.Radius + MinTurnRadius))
        {
            bIsTurningTowardsTarget = true;
            BeginTurnTowardsPosition(CurrentTarget.Position, MinTurnRadius, bIsTurningRight);
        }
    }


    function BeginState()
    {
        Log("Approuching");
        bIsTurningTowardsTarget = false;
    }
}

// Preform attack Run on the target.
state DiveAttacking
{
    function TickAI(float DeltaTime)
    {
        local vector PullUpTarget;
        //DebugPrintOnClient = false;
        // Check if we have dipped below the min hight above target
        if (!bIsPullingUp && Location.Z < (CurrentTarget.Position.Z + CurrentTarget.MinimumHeight))
        {
            Log("Begin Pullup");
            BeginDiveClimbToAngle(Pi/5, DiveClimbRadius);
            bIsPullingUp = true;
            bIsShootingAutoCannon = false;
            //DebugPrintOnClient = true;
        }
        // Check if we need to level out and stop pulling up
        else if (bIsPullingUp && !bIsLevelingOut && Location.Z >= CruisingHeight)
        {
            Log("Begin Levelout, "$CruisingHeight);
            BeginDiveClimbToAngle(0, DiveClimbRadius);
            bIsLevelingOut = true;
        }

        AutoCannonTime += DeltaTime;
        // Auto Cannon Shooting Logic
        if (bIsShootingAutoCannon && AutoCannonTime > ( (1.0f / AutoCannonRPM) * 60) )
        {
            AutoCannonTime = 0;
            //Log(AutoCannonFireOffset >> Rotation);
            //Spawn(AutoCannonProjectileClass,self,,Location + (AutoCannonFireOffset >> Rotation), GetProjectileFireRotation(AutoCannonSpread));
        }
    }

    function OnMoveEnd()
    {
        // Moving Straight after angling down to target.
        if (!bIsPullingUp && !bIsLevelingOut) {
            BeginStraight(Velocity, DivingSpeed, DivingAcceleration);
            bIsShootingAutoCannon = true;
        }
        // Moving Straight after pulling up.
        else if (bIsPullingUp && !bIsLevelingOut)
            BeginStraight(Velocity, ClimbingSpeed, DivingAcceleration);
        // Finished Leveling out, end attack run and start searching again.
        else if (bIsLevelingOut) {
            BeginStraight(Velocity, StandardSpeed, StraightAcceleration);
            GotoState('Searching');
        }
    }

    function BeginState()
    {
        bIsPullingUp = false;
        bIsLevelingOut = false;
        Log("Diving");
        BeginDiveClimbTowardsPosition(CurrentTarget.Position, 5000, false);
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

    Velocity = Normal(Velocity) * CurrentSpeed;

    // Make sure plane is always facing the direction it is traveling.
    Heading = OrthoRotation(velocity, velocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = class'UUnits'.static.RadiansToUnreal(BankAngle);
    SetRotation(Heading);
    //DesiredRotation = Heading;

    // Check if target met. Restrain from continued movement until new waypoint is set.
    if (VSize(V3ToV2(CurrentTarget.Position - Location)) <= CurrentTarget.Radius)
    {
        OnTargetReached();
    }
}

// MovementState related functions ---------------------------------------------

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
    TurnTowardsState.DesiredSpeed = TurnSpeed;
    TurnTowardsState.Acceleration = TurnAcceleration;

    MoveState = TurnTowardsState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_None);
    Velocity = VelocityPre;
}

// Same as turnTowardsPosition, but with diving and climbing.
function BeginDiveClimbTowardsPosition(vector TurnPositionGoal, float TurnRadius, bool bIsClimbing)
{
    local DHDiveClimbTowardsPosition DiveClimbState;
    local vector VelocityPre;

    DiveClimbState = new class'DHDiveClimbTowardsPosition';
    DiveClimbState.Airplane = self;
    DiveClimbState.TurnRadius = TurnRadius;
    DiveClimbState.bIsClimbing = bIsClimbing;
    DiveClimbState.PositionGoal = TurnPositionGoal;

    DiveClimbState.DesiredSpeedClimb = ClimbingSpeed;
    DiveClimbState.DesiredSpeedDive = DivingSpeed;
    DiveClimbState.Acceleration = DivingAcceleration;

    MoveState = DiveClimbState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_None);
    Velocity = VelocityPre;
}

// Diving and climbing to a specific angle.
function BeginDiveClimbToAngle(float TurnAngleGoal, float TurnRadius)
{
    local DHDiveClimbToAngle DiveClimbState;
    local vector VelocityPre;

    DiveClimbState = new class'DHDiveClimbToAngle';
    DiveClimbState.Airplane = self;
    DiveClimbState.TurnRadius = TurnRadius;
    DiveClimbState.DesiredAngleWorld = TurnAngleGoal;

    DiveClimbState.DesiredSpeedClimb = ClimbingSpeed;
    DiveClimbState.DesiredSpeedDive = DivingSpeed;
    DiveClimbState.Acceleration = DivingAcceleration;

    MoveState = DiveClimbState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_None);
    Velocity = VelocityPre;
}

// This begins the straight movement state. The plane will move in Direction
// forever.
function BeginStraight(vector Direction, float Speed, float Acceleration)
{
    local DHStraight StraightState;
    local vector VelocityPre;

    StraightState = new class'DHStraight';
    StraightState.Direction = Normal(Direction);
    StraightState.Airplane = self;
    StraightState.DesiredSpeed = Speed;
    StraightState.Acceleration = Acceleration;

    MoveState = StraightState;

    VelocityPre = Velocity;
    SetPhysics(PHYS_Flying);
    Velocity = VelocityPre;
}

// Attack related functions
function rotator GetProjectileFireRotation(float Spread)
{
    if (Spread > 0.0)
    {
        return rotator(vector(Rotation) + (VRand() * FRand() * Spread));
    }

    return Rotation;
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

//event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex);
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Log("Hit");
}

/*
event Touch( Actor Other )
{
    Log("Hit");
}
*/
defaultproperties
{
    AirplaneName="Airplane"
    DrawType=DT_Mesh
    bAlwaysRelevant=true
    bReplicateMovement=true
    bUpdateSimulatedPosition=true

    bCanBeDamaged=true

    bRotateToDesired=true

    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    bBlockKarma=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=True
    bBlockZeroExtentTraces=True
    bWorldGeometry=False

    RotationRate={Pitch=2000,Yaw=2000,Roll=2000}
    Physics = PHYS_Flying
    RemoteRole=ROLE_SimulatedProxy

    BankAngle = 0
    MaxBankAngle = 65
    BankRate = 0.65

    AutoCannonFireOffset={X=5000,Y=0,Z=-200}

    MinTurnRadius = 6000

    StandardSpeed = 4000
    StraightAcceleration = 150

    DivingSpeed = 5000
    DivingAcceleration = 300

    ClimbingSpeed = 1000

    TurnSpeed = 2000
    TurnAcceleration = 220

    CurrentSpeed = 0

    CruisingHeight = 100

    DiveClimbRadius = 3800


    //DebugPrintOnClient=false
}

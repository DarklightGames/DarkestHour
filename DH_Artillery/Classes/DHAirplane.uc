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

var int                 TeamIndex;
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
var float               DiveClimbAcceleration;

var float               ClimbingSpeed;      // Desired speed to use when climbing.

var float               CruisingHeight;     // This is the hight of the plane when flying normally. The hight it starts attack runs from and returns to.

// The current MoveState. What this variable is set to determines the movement pattern the plane preforms.
var DHMoveState         MoveState;

var bool            bIsPullingUp;
var bool            bIsLevelingOut;
var bool            bIsTurningTowardsTarget;
var float           PullUpAngle; // Angle in degrees to pull up towards durring a diving attack.

// Attack Control variables-----------------------------------------------------
enum EAttackType
{
    AT_DIVE_BOMB,
    AT_FLY_OVER_BOMB,
    AT_STRAFE
};

var EAttackType CurrentAttackType; // Type of attack run to be carried out on the current target.

var float StrafePullUpHeight; // Minimum height above the target before pulling up when strafe dive attacking.
var float DiveBombPullUpHeight; // Pull up hight for dive bomb attacks.

var float StrafeRadius; // Target radius for strafe attacks.
var float DiveBombRadius; // Target radius for dive bomb attacks.
var float FlyOverBombRadius; // Target radius for attacks.

// Represents an Attack Target that needs to be approached and attacked.
// TODO: target will need to keep track of clustering info!
struct STargetApproach
{
    var float Radius;       // How far from target to be before starting attack run. Must be facing the target by this distance.
    var float MinimumHeight; // Minimum height above the target before pulling up when dive attacking. This is the bottom of the
};

struct STargetCoordinates
{
    var vector Start;
    var vector End;
};

var DHAirplaneTarget    Target; // Current target.
var STargetApproach     TargetApproach;
var STargetCoordinates  TargetCoordinates;

struct CannonInfo
{
    var class<DHAirplaneCannon> CannonClass;
    var rotator RotationOffset;
    var vector LocationOffset;
};

var array<CannonInfo>       CannonInfos;
var array<DHAirplaneCannon> Cannons;

// Damage and crashing
var     class<VehicleDamagedEffect> DamageEffectClass;
var     name DamageEffectBone;
var     VehicleDamagedEffect DamageEffect;
var     float CrashAngle;
var     class<ROVehicleDestroyedEmitter> DestructionEffectClass;
var     float DeathSpiralVelocity;
var     float DeathSpiralAcceleration;
var     bool bIsCrashing;   // Used for triggering the crashing effects on client side.

// Bombs
var class<Projectile>   BombClass;
var float BombDropHeight; // how far above the pull up height to drop the bomb. Relative to pull up height.
var bool bHasDroppedBomb; // Set true after the plane has dropped its bomb durring the attack. RESET AFTER ATTACK RUN DONE.

// Rotation
var DHAirplaneRotator AirplaneModel;

replication
{
    unreliable if (Role == ROLE_Authority)
        AirplaneModel, Target;

    reliable if (Role == ROLE_Authority)
        bIsCrashing;
}


simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        AirplaneModel = Spawn(class'DHAirplaneRotator', Self);
        AirplaneModel.SetPhysics(PHYS_None);
        AirplaneModel.SetLocation(Location);
        AirplaneModel.SetPhysics(PHYS_Rotating);
        AirplaneModel.SetBase(self);

        CreateCannons();

        CurrentSpeed = StandardSpeed;
        CruisingHeight = Location.Z;
    }
    bIsCrashing = false;
}

function DestroyCannons()
{
    local int i;

    for (i = 0; i < Cannons.Length; ++i)
    {
        if (Cannons[i] != none)
        {
            Cannons[i].Destroy();
        }
    }

    Cannons.Length = 0;
}

// Gets an array of cannons that are suitable for the.
function array<DHAirplaneCannon> GetCannonsForTarget()
{
    local int i;
    local array<DHAirplaneCannon> CannonsForTarget;

    if (Target == none)
    {
        return CannonsForTarget;
    }

    // TODO: for now, all cannons; in future, pick
    for (i = 0 ; i < Cannons.Length; ++i)
    {
        CannonsForTarget[CannonsForTarget.Length] = Cannons[i];
    }

    return CannonsForTarget;
}

function CreateCannons()
{
    local int i;
    local DHAirplaneCannon Cannon;

    DestroyCannons();

    for (i = 0; i < CannonInfos.Length; ++i)
    {
        if (CannonInfos[i].CannonClass == none)
        {
            continue;
        }

        Cannon = Spawn(CannonInfos[i].CannonClass, self,, Location, Rotation);

        if (Cannon == none)
        {
            Warn("Failed to create cannon!");
        }

        Cannon.SetBase(AirplaneModel);
        Cannon.SetRelativeRotation(CannonInfos[i].RotationOffset);
        Cannon.SetRelativeLocation(CannonInfos[i].LocationOffset);

        Cannons[Cannons.Length] = Cannon;
    }
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
    // TODO: I think we can simply disable tick on the client instead of
    // checking the role. (ie. Disable('Tick');)
    if (Role == ROLE_Authority)
    {
        TickAI(DeltaTime);
        MovementUpdate(DeltaTime);
        TickAIPostMove(DeltaTime);
    }
}

// Tick function for the individual states.
function TickAI(float DeltaTime);

// Tick function for the states after MovementUpdate has completed.
function TickAIPostMove(float DeltaTime);

// Event for when the approach to the target has been finished.
function OnTargetReached();

// Called when a Movement has reached it's predefined goal. Overridden by states.
function OnMoveEnd();

// This function computes the priority of each individual target (highest
// first). It is passed into the cluster object to sort the targets out.
function float GetTargetPriority(Object O)
{
    if (O == none)
    {
        return 0.0;
    }

    // TODO: Things to take into account:
    //       * Target type
    //       * Distance to target
    //       * Available ammo
    //       * ...
    return 1.0;
}

function float GetTargetScanRadius()
{
    // TODO: Set the scan radius and conditions to something meaningful.
    return class'DHUnits'.static.MetersToUnreal(10000);
}

function float GetTargetClusterEpsilon()
{
    // TODO: Figure out how close points need to be to form optimal clusters
    //       (epsilon).
    return class'DHUnits'.static.MetersToUnreal(20);
}

// TODO: This is the link between the Target weapon type recomendations and the actual attack parameters
// Decide what attack to do on the target. Produces control signals.
function DecideAttack()
{
}

// This function is used by the Searching state to decide which target is next.
function PickTarget()
{
    local UClusters Targets;
    local UHeap TargetHeap;
    local UClusters.DataPoint P;
    local DHPawn OtherPawn;
    local Actor TargetActor;
    local array<Actor> TargetActors;
    local string TargetClassName;

    Targets = new class'UClusters';
    Targets.GetItemPriority = GetTargetPriority;

    // Collect the potential targets.
    foreach RadiusActors(class'DHPawn', OtherPawn, GetTargetScanRadius())
    {
        P.Item = OtherPawn;
        P.Location = OtherPawn.Location;

        Targets.Data[Targets.Data.Length] = P;
    }

    // Look for clusters.
    Targets.DBSCAN(GetTargetClusterEpsilon(), 1);

    // Convert the cluster data into a priority queue.
    // The most lucious target will bubble up to the top. It can be either a
    // single actor or a heap of actors (if it's a cluster).
    TargetHeap = Targets.ToHeap();

    // Get target's class name (for logging).
    TargetActor = Actor(TargetHeap.Peek());

    if (TargetActor != none)
    {
        // TODO: don't deal with single targets, necessarily.
        TargetActors[TargetActors.Length] = TargetActor;
        Target = class'DHAirplaneTarget'.static.CreateTargetFromActors(TargetActors);

        TargetClassName = string(TargetActor.Class);
    }

    // Get coordinates to the target.
    // TODO: Without course correction, target might drift away.
    if (Target != none && Targets.GetPriorityVector(TargetHeap, TargetCoordinates.Start, TargetCoordinates.End))
    {
        Log("Target acquired:" @ TargetClassName @ "@" @ TargetCoordinates.Start);
    }
    else
    {
        Log("No target!");
    }

    // Debug
    StartStrafe();
}

// Initial State. The plane enters into the combat area.
auto state Entrance
{
    function Timer()
    {
        GotoState('Searching');
    }

    function BeginState()
    {

        Log("Entrance");
        BeginStraight(vect(-1,0,0), StandardSpeed, StraightAcceleration);
        SetTimer(3, false);
    }
}

// This step simulates the plane looking for a new target to attack. When the state ends, a target is picked.
state Searching
{
    function Timer()
    {
        if (Role == ROLE_Authority)
        {
            PickTarget();
            DecideAttack();
        }

        GotoState('Approaching');
    }

    function BeginState()
    {
        Log("Searching");
        BeginStraight(Normal(velocity), StandardSpeed, StraightAcceleration);
        SetTimer(3, false);
    }
}

// Positions the airplane to be ready to preform the attack run. Typcally ends
// when plane has reached the proper distance to the target to begin the run.
state Approaching
{
    function OnTargetReached()
    {
        if (bIsTurningTowardsTarget)
        {
            if (CurrentAttackType == AT_STRAFE || CurrentAttackType == AT_DIVE_BOMB)
                GotoState('DiveAttacking');
            else if (CurrentAttackType == AT_FLY_OVER_BOMB)
                GotoState('FlyOverAttack');
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
        HeadingRotator = OrthoRotation(Velocity, Velocity cross vect(0, 0, 1), vect(0, 0, 1));
        HeadingRotator.Roll = 0;

        TargetInPlaneSpace = (Target.GetLocation() - Location) << HeadingRotator;

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

        if (!bIsTurningTowardsTarget && VSize(V3ToV2(TurnCriclePosition - Target.GetLocation()) ) > (TargetApproach.Radius + MinTurnRadius))
        {
            bIsTurningTowardsTarget = true;
            BeginTurnTowardsPosition(Target.GetLocation(), MinTurnRadius, bIsTurningRight);
        }
    }

    function BeginState()
    {
        Log("Approaching: " $ Target.GetLocation());
        bIsTurningTowardsTarget = false;
    }
}

state DiveAttacking
{
    function TickAI(float DeltaTime)
    {
        local vector PullUpTarget;

        // Check if we have dipped below the min hight above target
        if (!bIsPullingUp && Location.Z < (Target.GetLocation().Z + TargetApproach.MinimumHeight))
        {
            Log("Begin Pullup");
            BeginDiveClimbToAngle(class'UUnits'.static.DegreesToRadians(PullUpAngle), DiveClimbRadius);
            bIsPullingUp = true;

            StopFiringCannons();
        }
        // Check if we need to level out and stop pulling up
        else if (bIsPullingUp && !bIsLevelingOut && Location.Z >= CruisingHeight)
        {
            BeginDiveClimbToAngle(0, DiveClimbRadius);
            bIsLevelingOut = true;
        }
    }

    function OnMoveEnd()
    {
        // Moving Straight after angling down to target.
        if (!bIsPullingUp && !bIsLevelingOut)
        {
            BeginStraight(Velocity, DivingSpeed, DiveClimbAcceleration);

            StartFiringCannons();
        }
        // Moving Straight after pulling up.
        else if (bIsPullingUp && !bIsLevelingOut)
        {
            BeginStraight(Velocity, ClimbingSpeed, DiveClimbAcceleration);
        }
        // Finished Leveling out, end attack run and start searching again.
        else if (bIsLevelingOut)
        {
            BeginStraight(Velocity, StandardSpeed, StraightAcceleration);
            GotoState('Searching');
        }
    }

    function BeginState()
    {
        bIsPullingUp = false;
        bIsLevelingOut = false;
        Log("Diving");

        BeginDiveClimbTowardsPosition(TargetCoordinates.Start, 5000, false);
    }
}

state FlyOverAttack
{
    function BeginState()
    {
        Log("Fly Over");
    }
}

state Crashing
{
    function OnMoveEnd()
    {
        BeginStraight(Normal(velocity), DivingSpeed, DiveClimbAcceleration);
        Log("b: "$bIsCrashing);
    }

    function TickAI(float DeltaTime)
    {
        DeathSpiralVelocity += DeltaTime * DeathSpiralAcceleration;
        BankAngle += DeltaTime * DeathSpiralVelocity;

    }

    function BeginState()
    {
        Log("Crashing. God help me.");
        //StartDamageEffect();
        DeathSpiralVelocity = 0;
        bIsCrashing = true;
        BeginDiveClimbToAngle(class'UUnits'.static.DegreesToRadians(CrashAngle), 1500);
    }
}

// update position based on current position, velocity, and current waypoint.
function MovementUpdate(float DeltaTime)
{
    local rotator Heading;
    local float   DeltaTimeToUse;

    MoveState.Tick(DeltaTime);

    Velocity = Normal(Velocity) * CurrentSpeed;

    // Make sure plane is always facing the direction it is traveling.
    Heading = OrthoRotation(velocity, velocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = class'UUnits'.static.RadiansToUnreal(BankAngle);

    AirplaneModel.DesiredRotation = Heading;

    // TODO: Using rotation rate instead of bRotateToDesired could produce smoother replicated rotation.
    /*
    if (DeltaTime < 0.05)
    {
        DeltaTimeToUse = 0.05;
    }
    else
    {
        DeltaTimeToUse = DeltaTime;
    }

    // Correct one
    AirplaneModel.RotationRate = QuatToRotator( QuatProduct(  QuatFromRotator(Heading) , QuatInvert(QuatFromRotator(AirplaneModel.Rotation)) ) ) / DeltaTimeToUse;
    */

    // Check if target met.
    if (Target != none && VSize(V3ToV2(Target.GetLocation() - Location)) <= TargetApproach.Radius)
    {
        OnTargetReached();
    }
}

function StartStrafe()
{
    CurrentAttackType = AT_STRAFE;
    TargetApproach.Radius = StrafeRadius;
    TargetApproach.MinimumHeight = StrafePullUpHeight;
    GotoState('Approuching');
}

function StartDiveBomb()
{
    CurrentAttackType = AT_DIVE_BOMB;
    TargetApproach.Radius = DiveBombRadius;
    TargetApproach.MinimumHeight = DiveBombPullUpHeight;
    bHasDroppedBomb = false;
    GotoState('Approuching');
}

function StartFlyOverBomb()
{
    CurrentAttackType = AT_FLY_OVER_BOMB;
    TargetApproach.Radius = FlyOverBombRadius;
    bHasDroppedBomb = false;
    GotoState('Approuching');
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
    TurnTowardsState.PositionGoal = Target.GetLocation();
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
    DiveClimbState.Acceleration = DiveClimbAcceleration;

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
    DiveClimbState.Acceleration = DiveClimbAcceleration;

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

// Converts 3d vector into 2d vector.
static  function vector V3ToV2(vector InVector)
{
    local vector OutVector;

    OutVector.X = InVector.X;
    OutVector.Y = InVector.Y;
    OutVector.Z = 0;

    return OutVector;
}

simulated function StartDamageEffect()
{
    if (DamageEffect == none)
    {
        DamageEffect = Spawn(DamageEffectClass, self);
        //AttachToBone(DamageEffect, DamageEffectBone);
        DamageEffect.SetBase(self);
        DamageEffect.UpdateDamagedEffect(false, 0.0, true, false);
        DamageEffect.SetEffectScale(1.0);
        Log('Effect created');
        //DamageEffect.SetPhysics(PHYS_Flying);
    }
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Log("Hit");

    if (!IsInState('Crashing'))
    {
        GoToState('Crashing');
    }
}

event HitWall( vector HitNormal, Actor HitWall )
{
    Log("Ground Hit");
    Spawn(DestructionEffectClass);
    Destroy();
}

simulated function Destroyed()
{
    super.Destroyed();

    DestroyCannons();

    if (DamageEffect != none)
    {
        DamageEffect.Destroy();
    }
}

function StartFiringCannons()
{
    local int i;

    for (i = 0; i < Cannons.Length; ++i)
    {
        if (Cannons[i] != none)
        {
            Cannons[i].StartFiring();
        }
    }
}

function StopFiringCannons()
{
    local int i;

    for (i = 0; i < Cannons.Length; ++i)
    {
        if (Cannons[i] != none)
        {
            Cannons[i].StopFiring();
        }
    }
}

simulated event PostNetReceive()
{
    Log("post net recevie");
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bIsCrashing && DamageEffect != none)
        {
            Log("StartDamageEffect");
            StartDamageEffect();
        }
    }
}

defaultproperties
{
    AirplaneName="Airplane"
    DrawType=DT_Mesh

    bAlwaysRelevant=true
    bReplicateMovement=true
    bUpdateSimulatedPosition=true
    RemoteRole=ROLE_SimulatedProxy
    bCanBeDamaged=true

    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    bBlockKarma=false
    bProjTarget=true
    bBlockNonZeroExtentTraces=True
    bBlockZeroExtentTraces=True
    bWorldGeometry=False
    bUseCylinderCollision=false

    //bRotateToDesired=true
    //RotationRate={Pitch=2000,Yaw=2000,Roll=2000}
    Physics = PHYS_Flying

    BankAngle = 0
    MaxBankAngle = 65
    BankRate = 0.65

    DamageEffectClass=class'ROEngine.VehicleDamagedEffect'
    DamageEffectBone="body"
    CrashAngle=-60;
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    bIsCrashing=false
    DeathSpiralAcceleration=5

    MinTurnRadius = 6000
    PullUpAngle = 45

    StandardSpeed = 2000
    //StandardSpeed = 500
    StraightAcceleration = 150

    //DivingSpeed = 5000
    DivingSpeed = 800
    DiveClimbAcceleration = 400

    ClimbingSpeed = 1000

    TurnSpeed = 1200
    TurnAcceleration = 220

    DiveClimbRadius = 3800

    // MAX SPEED FOR DEBUG
    /*
    StandardSpeed = 5000
    DivingSpeed = 5000
    ClimbingSpeed = 5000
    TurnSpeed = 5000
    */

    StrafePullUpHeight=2000
    DiveBombPullUpHeight=2000

    StrafeRadius=15000
    DiveBombRadius=7000
    FlyOverBombRadius=13000

    BombDropHeight=300
}

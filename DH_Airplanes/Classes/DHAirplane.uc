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

enum ETargetType
{
    TARGET_None,
    TARGET_Infantry,
    TARGET_Vehicle,
    TARGET_ArmoredVehicle,
    TARGET_Gun,
    TARGET_Construction
};

struct STargetCoordinates
{
    var vector Start;
    var vector End;
};

var array<ETargetType>  TargetTypes;
var array<float>        TargetTypeModifiers;
var float               TargetPriorityFalloffStepInMeters;

var DHAirplaneTarget    Target; // Current target.
var STargetApproach     TargetApproach;
var STargetCoordinates  TargetCoordinates;

var float               ClusterEpsilonInMeters;
var int                 ClusterMinPoints;

struct WeaponInfo
{
    var class<DHAirplaneWeapon> WeaponClass;
    var rotator RotationOffset;
    var vector LocationOffset;
    var name WeaponBone;
};

var array<WeaponInfo>       LeftWeaponInfos;
var array<WeaponInfo>       RightWeaponInfos;
var array<WeaponInfo>       CenterWeaponInfos;
var array<DHAirplaneWeapon> Weapons;

// Damage and crashing
struct DamageEffectInfo
{
    var class<Emitter> DamageEffectClass;
    // TODO: Disabled because I could not get AttachToBone to work.
    //var name DamageEffectBone;
    var vector LocationOffset;
};

var     array<DamageEffectInfo> DamageEffectInfos;
var     array<Emitter> DamageEffects;

var     class<Emitter> DestructionEffectClass;
var     float CrashAngle;
var     float DeathSpiralVelocity;
var     float DeathSpiralMaxVelocity;
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
    reliable if (Role == ROLE_Authority)
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

        CreateWeapons();

        CurrentSpeed = StandardSpeed;
        CruisingHeight = Location.Z;
    }
}

function DestroyWeapons()
{
    local int i;

    for (i = 0; i < Weapons.Length; ++i)
    {
        if (Weapons[i] != none)
        {
            Weapons[i].Destroy();
        }
    }

    Weapons.Length = 0;
}

// Gets an array of cannons that are suitable for the target.
function array<DHAirplaneWeapon> GetWeaponForTarget()
{
    if (Target != none)
    {
        return class'DHAirplaneWeapon'.static.GetWeaponsForCluster(Weapons, Target.Actors);
    }
}

function CreateWeapons()
{
    local int i;
    local DHAirplaneWeapon Weapon, WeaponPair;

    DestroyWeapons();

    for (i = 0; i < CenterWeaponInfos.Length; ++i)
    {
        Weapon = CreateWeapon(CenterWeaponInfos[i]);

        if (Weapon == none)
        {
            continue;
        }

        Weapon.WeaponInfo = CenterWeaponInfos.Length;
        Weapon.MountAxis = MOUNT_Center;
        Weapons[Weapons.Length] = Weapon;
    }

    for (i = 0; i < LeftWeaponInfos.Length || i < RightWeaponInfos.Length; ++i)
    {
        if (i < LeftWeaponInfos.Length)
        {
            Weapon = CreateWeapon(LeftWeaponInfos[i]);

            if (Weapon != none)
            {
                Weapon.WeaponInfo = LeftWeaponInfos.Length;
                Weapon.MountAxis = MOUNT_Left;
                Weapons[Weapons.Length] = Weapon;

                if (i < RightWeaponInfos.Length)
                {
                    WeaponPair = CreateWeapon(RightWeaponInfos[i]);

                    if (WeaponPair != none)
                    {
                        WeaponPair.WeaponInfo = RightWeaponInfos.Length;
                        WeaponPair.MountAxis = MOUNT_Right;
                        Weapon.WeaponPair = WeaponPair;
                    }
                }
            }
        }
        else
        {
            Weapon = CreateWeapon(RightWeaponInfos[i]);

            if (Weapon != none)
            {
                Weapon.WeaponInfo = RightWeaponInfos.Length;
                Weapon.MountAxis = MOUNT_Right;
                Weapons[Weapons.Length] = Weapon;
            }
        }
    }
}

function DHAirplaneWeapon CreateWeapon(WeaponInfo WI)
{
    local DHAirplaneWeapon Weapon;

    if (WI.WeaponClass == none)
    {
        return none;
    }

    Weapon = Spawn(WI.WeaponClass, self,, Location, Rotation);

    if (Weapon == none)
    {
        Warn("Failed to create weapon!");
    }

    AirplaneModel.AttachToBone(Weapon, WI.WeaponBone);
    Weapon.SetRelativeRotation(WI.RotationOffset);
    Weapon.SetRelativeLocation(WI.LocationOffset);
}

// Tick needed to make AI decisions on server.
simulated function Tick(float DeltaTime)
{
    // TODO: I think we can simply disable tick on the client instead of
    // checking the role. (ie. Disable('Tick');)
    // I know but right know I like to use it for debugging.

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
    local Actor A;
    local float Priority;
    local bool bAirplaneCanDamageTarget;
    local int i, DistanceModifier;
    local ETargetType TargetType;

    A = Actor(O);

    if (A == none)
    {
        return 0.0;
    }

    TargetType = GetTargetType(A);

    // First we check if we have appropriate guns and ammo to damage the target
    for (i = 0; i < Weapons.Length; ++i)
    {
        if (Weapons[i].CanFire() && Weapons[i].CanDamageTargetType(TargetType))
        {
            bAirplaneCanDamageTarget = true;
            break;
        }
    }

    if (!bAirplaneCanDamageTarget)
    {
        return 0.0;
    }

    switch (TargetType)
    {
        case TARGET_ArmoredVehicle:
        case TARGET_Vehicle:
        case TARGET_Gun:
            Priority = GetTargetTypeModifier(TargetType) + GetTargetCrewCount(A) * GetTargetTypeModifier(TARGET_Infantry);
        default:
            Priority = GetTargetTypeModifier(TargetType);
    }

    // Give closer targets a higher priority
    DistanceModifier = int(VSize(Location - A.Location) / class'DHUnits'.static.MetersToUnreal(TargetPriorityFalloffStepInMeters));

    if (DistanceModifier > 0)
    {
        Priority /= DistanceModifier;
    }

    // TODO: Add proximity-to-airstrike-marker modifier to allow squad leaders
    // select priority targets.
    return Priority;
}

// TODO: Move this to DHVehicle
function int GetTargetCrewCount(Actor A)
{
    local int Count;
    local DHVehicle V;
    local VehicleWeaponPawn WP;
    local int i;

    V = DHVehicle(A);

    if (V == none)
    {
        return 0.0;
    }

    if (V.Driver != none && !V.Driver.bDeleteMe && V.Driver.Health > 0)
    {
        ++Count;
    }

    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = V.WeaponPawns[i];
        Count += int(WP != none && WP.Driver != none && !WP.Driver.bDeleteMe && WP.Driver.Health > 0);
    }

    return Count;
}

static function float GetTargetTypeModifier(ETargetType TargetType)
{
    local int Index;

    Index = int(TargetType);

    if (Index < default.TargetTypeModifiers.Length)
    {
        return default.TargetTypeModifiers[Index];
    }
}

static function ETargetType GetTargetType(Actor A)
{
    local name TargetClass;
    local DHPawn P;

    if (A == none)
    {
        return TARGET_None;
    }

    if (A.IsA('DHATGun'))
    {
        return TARGET_Gun;
    }

    if (A.IsA('DHArmoredVehicle'))
    {
        return TARGET_ArmoredVehicle;
    }

    if (A.IsA('DHVehicle'))
    {
        return TARGET_Vehicle;
    }

    if (A.IsA('DHConstruction'))
    {
        return TARGET_Construction;
    }

    // Infantry
    // TODO: Add a case for crewed mortars

    P = DHPawn(A);

    if (P != none && P.PlayerReplicationInfo != none)
    {
        return TARGET_Infantry;
    }

    return TARGET_None;
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

static function array<Actor> GetPotentialTargets(Actor ForActor, float Radius)
{
    local Pawn P;
    local array<Actor> Targets;

    foreach ForActor.RadiusActors(class'Pawn', P, Radius)
    {
        if (P.IsA('ROVehicleWeaponPawn'))
        {
            continue;
        }

        Targets[Targets.Length] = P;
    }
}

// This function is used by the Searching state to decide which target is next.
function PickTarget()
{
    local UClusters Targets;
    local UHeap QueuedTargets, TargetCluster;
    local UClusters.DataPoint P;
    local DHPawn OtherPawn;
    local Actor TargetActor;
    local array<Actor> TargetActors;
    local string TargetClassName;
    local Functor_float_Object PriorityFunction;
    local int i;

    PriorityFunction = new class'Functor_float_Object';
    PriorityFunction.DelegateFunction = GetTargetPriority;

    Targets = class'UClusters'.static.CreateFromActors(GetPotentialTargets(self, 10000),
                                                       PriorityFunction,
                                                       class'DHUnits'.static.MetersToUnreal(ClusterEpsilonInMeters),
                                                       ClusterMinPoints);
    TargetActors = Targets.GetPriorityActors();

    if (TargetActors.Length > 0)
    {
        if (Target == none)
        {
            Target = Spawn(class'DHAirplaneTarget');
        }

        if (Target == none)
        {
            Warn("Failed to create the target info");
        }
        else
        {
            Target.Actors = TargetActors;
        }
    }

    // DEBUG: Get target's class name (for logging).
    QueuedTargets = Targets.ToHeap();
    TargetClassName = string(QueuedTargets.Peek());

    // Get coordinates to the target.
    // TODO: Without course correction, target might drift away.
    if (Target != none && Target.IsValid() && Targets.GetPriorityVector(QueuedTargets, TargetCoordinates.Start, TargetCoordinates.End))
    {
        Log("Target acquired:" @ TargetClassName @ "@" @ TargetCoordinates.Start);
    }
    else
    {
        // TODO: The plane still gets a null vector for the target, because the
        // flight logic always expects a target. This might result in some
        // violent smashing into the ground.
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
        // Check if we have dipped below the min hight above target
        if (!bIsPullingUp && Location.Z < (Target.GetLocation().Z + TargetApproach.MinimumHeight))
        {
            Log("Begin Pullup");
            BeginDiveClimbToAngle(class'UUnits'.static.DegreesToRadians(PullUpAngle), DiveClimbRadius);
            bIsPullingUp = true;

            StopFiringCannons(-1);
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

            StartFiringCannons(GetCannonFlagsForTarget());
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
        local int i;

        bIsPullingUp = false;
        bIsLevelingOut = false;
        Log("Diving");

        BeginDiveClimbTowardsPosition(TargetCoordinates.Start, 5000, false);

        // ARM WEAPONS HERE
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

        AirplaneModel.bRotateToDesired = false;
        AirplaneModel.bFixedRotationDir = true;

        AirplaneModel.RotationRate.Roll = 0;
        AirplaneModel.RotationRate.Pitch = 0;
        AirplaneModel.RotationRate.Yaw = 0;
    }

    function TickAI(float DeltaTime)
    {
        AirplaneModel.RotationRate.Roll += DeltaTime * DeathSpiralAcceleration;

        if(AirplaneModel.RotationRate.Roll > DeathSpiralMaxVelocity)
            AirplaneModel.RotationRate.Roll = DeathSpiralMaxVelocity;

        Log(AirplaneModel.RotationRate.Roll);
    }

    function BeginState()
    {
        Log("Crashing. God help me.");
        bIsCrashing = true;

        BeginDiveClimbToAngle(class'UUnits'.static.DegreesToRadians(CrashAngle), DiveClimbRadius);
    }
}

simulated function StartDamageEffect()
{
    local int i;
    local Emitter DamageEffect;

    if(DamageEffects.Length != 0)
        return;

    for (i = 0; i < DamageEffectInfos.Length; i++)
    {
        if (DamageEffectInfos[i].DamageEffectClass == none)
        {
            continue;
        }

        DamageEffect = Spawn(DamageEffectInfos[i].DamageEffectClass, self,,AirplaneModel.Location + (DamageEffectInfos[i].LocationOffset << AirplaneModel.Rotation),AirplaneModel.Rotation);

        if (DamageEffect == none)
        {
            Warn("Failed to spawn damage effect emitter.");
            continue;
        }

        //AirplaneModel.AttachToBone(DamageEffect, DamageEffectInfos[i].DamageEffectBone);

        DamageEffect.SetRelativeLocation(DamageEffectInfos[i].LocationOffset);
        //DamageEffect.SetRelativeRotation(DamageEffectInfos[i].RotationOffset);
        DamageEffect.SetBase(AirplaneModel);

        DamageEffects[DamageEffects.Length] = DamageEffect;
    }
}

simulated function DestroyDamageEffects()
{
    local int i;
    Log(AirplaneModel.Location);
    for(i = 0; i < DamageEffects.Length; i++)
    {
        Log(DamageEffects[i].Location);
        DamageEffects[i].Destroy();
    }

    DamageEffects.Length = 0;
}

// update position based on current position, velocity, and current waypoint.
function MovementUpdate(float DeltaTime)
{
    local rotator Heading;

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

    AirplaneModel.Destroy();

    DestroyWeapons();
    DestroyDamageEffects();

    Target.Destroy();
}

function int GetCannonFlagsForTarget()
{
    local int CannonFlags, i;

    for (i = 0; i < Weapons.Length; ++i)
    {
        // TODO: fill this in with something that looks at target composition and
        // builds the cannon flags.
        CannonFlags = CannonFlags | (1 << i);
    }

    return CannonFlags;
}

function StartFiringCannons(int CannonFlags)
{
    local int i;

    for (i = 0; i < Weapons.Length; ++i)
    {
        // TODO: !
        if (Weapons[i] != none && (CannonFlags & (1 << i)) != 0)
        {
            Weapons[i].StartFiring();
        }
    }
}

function StopFiringCannons(int CannonFlags)
{
    local int i;

    for (i = 0; i < Weapons.Length; ++i)
    {
        // TODO: !
        if (Weapons[i] != none && (CannonFlags & (1 << i)) != 0)
        {
            Weapons[i].StopFiring();
        }
    }
}

simulated event PostNetReceive()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bIsCrashing && DamageEffects.Length == 0)
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

    bNetNotify=true
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

    Physics = PHYS_Flying

    BankAngle = 0
    MaxBankAngle = 65
    BankRate = 0.65

    DamageEffectInfos(0)=(DamageEffectClass=class'ROEngine.VehicleDamagedEffect')
    DamageEffectInfos(1)=(DamageEffectClass=class'ROEngine.VehicleDamagedEffect',LocationOffset=(X=0,Y=500,Z=0))

    CrashAngle=-60;
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'

    bIsCrashing=false
    DeathSpiralAcceleration=80000
    DeathSpiralMaxVelocity=37000

    MinTurnRadius = 6000
    PullUpAngle = 45

    StandardSpeed = 4000
    StraightAcceleration = 150

    DivingSpeed = 5000
    DiveClimbAcceleration = 1000

    ClimbingSpeed = 1000

    TurnSpeed = 1200
    TurnAcceleration = 220

    CurrentSpeed = 2000
    CruisingHeight = 100
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

    // TARGETTING:

    ClusterMinPoints=1
    ClusterEpsilonInMeters=20
    TargetPriorityFalloffStepInMeters=500

    // TargetTypeModifiers define in which order the plane will target things.
    // All crewed targets will have an infantry modifiers added for each crew memeber.
    TargetTypes(0)=TARGET_None
    TargetTypeModifiers(0)=0.0

    TargetTypes(1)=TARGET_Infantry
    TargetTypeModifiers(1)=1.0

    TargetTypes(2)=TARGET_Vehicle // crewed
    TargetTypeModifiers(2)=4.1

    TargetTypes(3)=TARGET_ArmoredVehicle // crewed
    TargetTypeModifiers(3)=8.3

    TargetTypes(4)=TARGET_Gun // crewed
    TargetTypeModifiers(4)=0.0

    TargetTypes(5)=TARGET_Contruction
    TargetTypeModifiers(5)=0.0
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTreadCraft extends ROTreadCraft
        abstract;

#exec OBJ LOAD FILE=..\textures\DH_InterfaceArt_tex.utx
#exec OBJ LOAD FILE=..\sounds\Amb_Destruction.uax
#exec OBJ LOAD FILE=..\sounds\DH_AlliedVehicleSounds2.uax
#exec OBJ LOAD FILE=..\textures\DH_VehicleOptics_tex.utx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex2.utx

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

// Set-up for new hitpoint types
enum ENewHitPointType
{
    NHP_Normal,
    NHP_GunOptics,
    NHP_PeriscopeOptics, //should we make the peri-optics replaceable?
    NHP_Traverse,
    NHP_GunPitch,
    NHP_Hull, //all kinds of nasty stuff can happen to driver, bow gunner, components, etc
};

var     ENewHitPointType                    NewHitPointType;

struct NewHitpoint
{
    var() float             PointRadius;        // Squared radius of the head of the pawn that is vulnerable to headshots
    var() float             PointHeight;        // Distance from base of neck to center of head - used for headshot calculation
    var() float             PointScale;
    var() name              PointBone;          // Bone to reference in offset
    var() vector            PointOffset;        // Amount to offset the hitpoint from the bone
    var() bool              bPenetrationPoint;  // This is a penetration point, open hatch, etc
    var() float             DamageMultiplier;   // Amount to scale damage to the vehicle if this point is hit
    var() ENewHitPointType  NewHitPointType;    // What type of hit point this is
};

var()   array<NewHitpoint>      NewVehHitpoints;        // An array of possible small points that can be hit. Index zero is always the driver

var     bool    bProjectilePenetrated; //Shell has passed penetration test and has entered the hull or turret
var()   bool    bAllowRiders;
var     bool    bAssaultWeaponHit;  //used to defeat the Stug/JP bug
var     bool    bIsAssaultGun;

var     bool    bWasShatterProne;
var     bool    bRoundShattered;

var     int     UnbuttonedPositionIndex;
var     bool    bSpecialExiting;

var() material  DamagedTreadPanner;
var     int     LeftTreadIndex;
var     int     RightTreadIndex;

var     bool    bRearHit;
var     float   MaxCriticalSpeed;

var     float   AmmoIgnitionProbability; // Allows for tank by tank ammo box ignition probabilities
var     float   TreadDamageThreshold;    // Allows for tank by tank adjustment of tread vulnerability
var     float   DriverKillChance;        //Chance that shrapnel will kill driver
var     float   GunnerKillChance;        //Chance that shrapnel will kill bow gunner

// Turret damage stuff
var     bool    bWasTurretHit; //used to prevent lower turret hits from registering as tread hits
var     float   CommanderKillChance;
var     float   OpticsDamageChance;
var     float   GunDamageChance;
var     float   TraverseDamageChance;
var     float   TurretDetonationThreshold;  //Chance that turret ammo will go up

// Fire stuff- Shurek & Ch!cKeN
var()   name                FireAttachBone;
var()   vector              FireEffectOffset;
var()   float               FireDamage;
var     float               EngineFireDamagePerSec;
var     float               EngineFireChance;
var     float               EngineFireHEATChance;
var     float               HullFireChance;
var     float               HullFireHEATChance;
var     class<DamageType>   VehicleBurningDamType;
var     float               PlayerFireDamagePerSec;
var     float               BurnTime;
var     float               EngineBurnTime;
var     float               FireCheckTime;
//var() float               DamagedHealthFireFactor; // Replaces DamagedEffectHealthFireFactor for calculating when a tank should catch fire from lack of health
var()   bool                bFirstHit;
var()   bool                bOnFire;  // Hull is on fire
var()   bool                bEngineOnFire; // Engine is on fire
var     bool                bWasHEATRound; // Whether the round doing damage was a HEAT round or not
var     Controller          WhoSetOnFire;
var     Controller          WhoSetEngineOnFire;
var     int                 FireStarterTeam;
var     bool                bTurretFireTriggered; // To stop multiple calls to the TankCannon
var     bool                bHullMGFireTriggered;
var     float               DriverHatchBurnTime;
var     float               FireDetonationChance; // Chance of a fire blowing a tank up, runs each time the fire does damage
var     float               EngineToHullFireChance;  // Chance of an engine fire spreading to the rest of the tank, runs each time engine takes fire damage

var     texture    PeriscopeOverlay;
var     texture    DamagedPeriscopeOverlay;
var     bool       bPeriscopeDamaged;

// new sounds
var     sound                   VehicleBurningSound;
var     sound                   DestroyedBurningSound;
var     sound                   DamagedStartUpSound;
var     sound                   DamagedShutDownSound;
var     sound                   SmokingEngineSound;

var     class<VehicleDamagedEffect>             FireEffectClass;
var     VehicleDamagedEffect                    DriverHatchFireEffect;

var int EngineHealthMax;

// Engine stuff
var     bool                bEngineDead;   //tank engine is damaged and cannot run or be restarted...ever
var     bool                bEngineOff;    //tank engine is simply switched off
var     bool                bOldEngineOff;
var     float               IgnitionSwitchTime;

var     float               DriverTraceDist; //CheckReset() variable

//Upper armor values
var     float           UFrontArmorFactor;
var     float           URightArmorFactor;
var     float           ULeftArmorFactor;
var     float           URearArmorFactor;

var     float           UFrontArmorSlope;
var     float           URightArmorSlope;
var     float           ULeftArmorSlope;
var     float           URearArmorSlope;

//used only for detecting assault gun mantlet hits
var     float           GunMantletArmorFactor;
var     float           GunMantletSlope;

var     float           DHArmorSlopeTable[16];

var     float           PointValue; // Used for scoring - 1 = Jeeps/Trucks; 2 = Light Tank/Recon Vehicle/AT Gun; 3 = Medium Tank; 4 = Medium Heavy (Pz V,JP), 5 = Heavy Tank

//Debugging help and customizable stuff
var bool    bDrawPenetration;
var bool    bDebuggingText;
var bool    bPenetrationText;
var bool    bDebugTreadText;
var bool    bLogPenetration;
var bool    bDebugExitPositions;

var float   WaitForCrewTime;

var bool    bEmittersOn;

var bool    bMustBeUnbuttonedToBecomePassenger;
var int     FirstPassengerWeaponPawnIndex;

replication
{
    reliable if (bNetDirty && Role==ROLE_Authority)
        EngineHealthMax, UnbuttonedPositionIndex, bEngineOnFire, bOnFire;

    reliable if (bNetDirty && bNetOwner && Role==ROLE_Authority)
        MaxCriticalSpeed;

    reliable if (Role < ROLE_Authority)
        TakeFireDamage, ServerStartEngine, ServerToggleDebugExits; // Matt: added ServerToggleDebugExits

    reliable if (Role == ROLE_Authority)
        bProjectilePenetrated, bFirstHit, bRoundShattered, bPeriscopeDamaged;

    reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bEngineDead, bEngineOff;
}

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

//http://wiki.beyondunreal.com/Legacy:Insertion_Sort
static final function InsertSortEPPArray(out array<ExitPositionPair> MyArray, int LowerBound, int UpperBound)
{
    local int InsertIndex, RemovedIndex;

    if (LowerBound < UpperBound)
    {
        for (RemovedIndex = LowerBound + 1; RemovedIndex <= UpperBound; ++RemovedIndex)
        {
            InsertIndex = RemovedIndex;

            while (InsertIndex > LowerBound && MyArray[InsertIndex - 1] > MyArray[RemovedIndex])
            {
                --InsertIndex;
            }

            if ( RemovedIndex != InsertIndex )
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

    ExitPositionPairs.Length = ExitPositions.Length;

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    if (class'DH_ROTreadCraft'.default.bDebugExitPositions) // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all DH_ROTreadCrafts
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

static function StaticPrecache(LevelInfo L)
{
        super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');

    super.UpdatePrecacheMaterials();
}

//Don't need this in DH
simulated function bool HitPenetrationPoint(vector HitLocation, vector HitRay);

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

// Modified to fix RO bug where players can't get into a rider position on a driven tank if 1st rider position is already occupied
// Original often returned MG as ClosestWeaponPawn, which infantry cannot use, so we now check player can use weapon pawn & it's available)
function Vehicle FindEntryVehicle(Pawn P)
{
    local  float              DistSquared, ClosestDistSquared, BackupDistSquared; // use distance squared to compare to VSizeSquared (faster than VSize)
    local  int                x;
    local  VehicleWeaponPawn  ClosestWeaponPawn, BackupWeaponPawn;
    local  Bot                B;
    local  Vehicle            VehicleGoal;
    local  bool               bPlayerIsTankCrew;

    B = Bot(P.Controller);

    // Bots know what they want
    if (B != none)
    {
        // This is what's added in ROTreadCraft, worked into main function from ROVehicle ("code to get the bots using tanks better")
        if (WeaponPawns.length != 0 && IsVehicleEmpty())
        {
            for (x = WeaponPawns.length -1; x >= 0; x--)
            {
                if (WeaponPawns[x].Driver == none)
                {
                    return WeaponPawns[x];
                }
            }
        }

        VehicleGoal = Vehicle(B.RouteGoal);

        if (VehicleGoal == none)
        {
            return none;
        }

        if (VehicleGoal == self)
        {
            if (Driver == none)
            {
                return self;
            }

            return none;
        }

        for (x = 0; x < WeaponPawns.length; x++)
        {
            if (VehicleGoal == WeaponPawns[x])
            {
                if (WeaponPawns[x].Driver == none)
                {
                    return WeaponPawns[x];
                }

                if (Driver == none)
                {
                    return self;
                }

                return none;
            }
        }

        return none;
    }

    // Always go with driver's seat if no driver (even if player isn't tank crew, TryToDrive puts them in any available rider slot)
    if (Driver == none)
    {
        DistSquared = VSizeSquared(P.Location - (Location + (EntryPosition >> Rotation)));

        if (DistSquared < Square(EntryRadius))
        {
            return self;
        }

        for (x = 0; x < WeaponPawns.length; x++)
        {
            DistSquared = VSizeSquared(P.Location - (WeaponPawns[x].Location + (WeaponPawns[x].EntryPosition >> Rotation)));

            if (DistSquared < Square(WeaponPawns[x].EntryRadius))
            {
                return self;
            }
        }

        return none;
    }

    // Record if player is allowed to use tanks
    if (P.IsHumanControlled() && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none &&
        ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew)
    {
        bPlayerIsTankCrew = true;
    }

    // Set some high starting values so we can record when we find a closer weapon pawn (squared distances are equivalent to 1,000 units or 16.5m)
    ClosestDistSquared = 1000000.0;
    BackupDistSquared = 1000000.0; // added so we can check the closest weapon pawn player could occupy, even though it may be out of range (vehicle itself may be in range)

    // Loop through weapon pawns to check if we are in entry range
    for (x = 0; x < WeaponPawns.length; x++)
    {
        // Ignore this weapon pawn if it's already occupied by another player
        if (WeaponPawns[x] == none || (WeaponPawns[x].Driver != none && WeaponPawns[x].Driver.IsHumanControlled()))
        {
            continue;
        }

        // Stop non-tanker from trying to enter a tank crew position (cannon or MG), which would be unsuccessful & stop them reaching a valid rider slot
        if (!bPlayerIsTankCrew && WeaponPawns[x].IsA('ROVehicleWeaponPawn') && ROVehicleWeaponPawn(WeaponPawns[x]).bMustBeTankCrew)
        {
            continue;
        }

        // Calculate player's distance from this weapon pawn
        DistSquared = VSizeSquared(P.Location - (WeaponPawns[x].Location + (WeaponPawns[x].EntryPosition >> Rotation)));

        // Check if this weapon pawn is currently the closest one within range that the player can use
        if (DistSquared < ClosestDistSquared && DistSquared < Square(WeaponPawns[x].EntryRadius))
        {
            ClosestDistSquared = DistSquared;
            ClosestWeaponPawn = WeaponPawns[x];
        }
        // If not, check if this is closest 'backup' weapon pawn player could occupy (used below if vehicle itself in range but no weapon pawn in range)
        else if (ClosestWeaponPawn == none && DistSquared < BackupDistSquared)
        {
            BackupDistSquared = DistSquared;
            BackupWeaponPawn = WeaponPawns[x];
        }
    }

    // If we have a weapon pawn in range, return the closest recorded
    if (ClosestWeaponPawn != none)
    {
        return ClosestWeaponPawn;
    }
    // Or if we have a backup weapon pawn & the vehicle itself is in range, return the backup weapon pawn
    else if (BackupWeaponPawn != none && VSizeSquared(P.Location - (Location + (EntryPosition >> Rotation))) < Square(EntryRadius))
    {
        return BackupWeaponPawn;
    }
    // No valid slots in range
    else
    {
        return none;
    }
}

function KDriverEnter(Pawn p)
{
    local int x;

    DriverPositionIndex=InitialPositionIndex;
    PreviousPositionIndex=InitialPositionIndex;

    // lets bots start vehicle
    if (!p.IsHumanControlled())
       bEngineOff=false;

    //check to see if Engine is already on when entering
    if (bEngineOff)
    {
        if (IdleSound != none)
        AmbientSound = none;

    }
    else if (bEngineDead)
    {
        if (IdleSound != none)
        AmbientSound = VehicleBurningSound;
    }
    else
    {
        if (IdleSound != none)
        AmbientSound = IdleSound;
    }

    ResetTime = Level.TimeSeconds - 1;
    Instigator = self;

    super(Vehicle).KDriverEnter(P);

    if (Weapons.Length > 0)
        Weapons[ActiveWeapon].bActive = true;

    Driver.bSetPCRotOnPossess = false; //so when driver gets out he'll be facing the same direction as he was inside the vehicle

    for (x = 0; x < Weapons.length; x++)
    {
        if (Weapons[x] == none)
        {
            Weapons.Remove(x, 1);
            x--;
        }
        else
        {
            Weapons[x].NetUpdateFrequency = 20; //20 default
            ClientRegisterVehicleWeapon(Weapons[x], x);
        }
    }
}

//overriding here because we don't want exhaust/dust to start up until engine starts
simulated event DrivingStatusChanged()
{
    local PlayerController PC;

    PC = Level.GetLocalPlayerController();

    if (!bDriving || bEngineOff || bEngineDead)
    {
        if (LeftTreadPanner != none)
            LeftTreadPanner.PanRate = 0.0;

        if (RightTreadPanner != none)
            RightTreadPanner.PanRate = 0.0;

        // Not moving, so no motion sound
        MotionSoundVolume=0.0;
        UpdateMovementSound();
    }

    if (bDriving && PC != none && (PC.ViewTarget == none || !(PC.ViewTarget.IsJoinedTo(self))))
        bDropDetail = (Level.bDropDetail || (Level.DetailMode == DM_Low));
    else
        bDropDetail = false;

    //we want the fire code to continue running even if no one is in the vehicle
    if (bDriving || bOnFire || bEngineOnFire)
        Enable('Tick');
    else
        Disable('Tick');

    super(ROVehicle).DrivingStatusChanged();

    //moved exhaust and dust spawning to StartEngineFunction

}

// Overriden to add hint
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    //Engine start/stop hint
    DHPlayer(PC).QueueHint(40, true);

}

function Fire(optional float F)
{

    if (Level.NetMode != NM_DedicatedServer)
        ServerStartEngine();
}

simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        for(i = 0; i < Dust.Length; i++)
            if (Dust[i] != none)
                Dust[i].Kill();

        Dust.Length = 0;

        for(i = 0; i < ExhaustPipes.Length; i++)
            if (ExhaustPipes[i].ExhaustEffect != none)
                ExhaustPipes[i].ExhaustEffect.Kill();
    }

    bEmittersOn = false;
}

simulated function StartEmitters()
{
    local int i;
    local coords WheelCoords;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        Dust.length = Wheels.length;

        for(i=0; i<Wheels.Length; i++)
        {
            if (Dust[i] != none)
                Dust[i].Destroy();

            // Create wheel dust emitters.
            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0,0,-1) * Wheels[i].WheelRadius) >> Rotation));

            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Dust[i].MaxSpritePPS=3;
                Dust[i].MaxMeshPPS=3;
            }

            Dust[i].SetBase(self);
            Dust[i].SetDirtColor(Level.DustColor);
        }

        for(i=0; i<ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
                ExhaustPipes[i].ExhaustEffect.Destroy();

            // Create exhaust emitters.
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
                ExhaustPipes[i].ExhaustEffect = spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            else
                ExhaustPipes[i].ExhaustEffect = spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);

            ExhaustPipes[i].ExhaustEffect.SetBase(self);
        }
    }

    bEmittersOn = true;
}

// Server side function called to switch engine
function ServerStartEngine()
{
    if (bEngineDead)
        return; //can't turn Engine on or off if its Dead

    if (!bEngineOff)
    {
        //so that people can't spam the ignition switch and turn on/off while moving
        if ((Level.TimeSeconds - IgnitionSwitchTime > 4.0) && Throttle == 0)
        {
            if (AmbientSound != none)
                AmbientSound = none;

            if (ShutDownSound != none)
                PlaySound(ShutDownSound, SLOT_None, 1.0);

            Throttle=0;
            ThrottleAmount=0;
            bDisableThrottle=true;
            bWantsToThrottle=false;
            bEngineOff=true;

            TurnDamping = 0.0;

            IgnitionSwitchTime = Level.TimeSeconds;

            if (WeaponPawns[0] != none && WeaponPawns[0].Gun != none && DH_ROTankCannon(WeaponPawns[0].Gun) != none)
                DH_ROTankCannon(WeaponPawns[0].Gun).bManualTurret = true;
        }
    }
    else
    {
        if (Level.TimeSeconds - IgnitionSwitchTime > 4.0)
        {
            if (StartUpSound != none)
                PlaySound(StartUpSound, SLOT_None, 1.0);

            if (IdleSound != none)
                AmbientSound = IdleSound;

            Throttle=0;
            bDisableThrottle=false;
            bWantsToThrottle=true;
            bEngineOff=false;

            IgnitionSwitchTime = Level.TimeSeconds;

            if (WeaponPawns[0] != none && WeaponPawns[0].Gun != none && DH_ROTankCannon(WeaponPawns[0].Gun) != none)
                DH_ROTankCannon(WeaponPawns[0].Gun).bManualTurret = false;
        }
    }
}


// Overridden here to force the server to go to state "ViewTransition", used to prevent players exiting before the unbutton anim has finished
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
        }
    }
}

// Overridden to prevent players exiting unless unbuttoned first
function bool KDriverLeave(bool bForceLeave)
{

    // if player is not unbuttoned and is trying to exit rather than switch positions, don't let them out
    // bForceLeave is always true for position switch, so checking against false means no risk of locking someone in one slot
    if (!bForceLeave && !bSpecialExiting && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        DenyEntry(Instigator, 4); // I realise that this is actually denying EXIT, but the function does the exact same thing - Ch!cken
        return false;
    }
    else if (!bForceLeave && bSpecialExiting)
    {
        DenyEntry(Instigator, 5); //Stug, JP, and Panzer III drivers must exit through commander's hatch
        return false;
    }
    else
        super.KDriverLeave(bForceLeave);

}

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{

    MotionSoundVolume=0.0;
    UpdateMovementSound();

    if (ActiveWeapon < Weapons.Length)
    {
        Weapons[ActiveWeapon].bActive = false;
        Weapons[ActiveWeapon].AmbientSound = none;
    }

    if (!bNeverReset && ParentFactory != none && (VSize(Location - ParentFactory.Location) > 5000.0 || !FastTrace(ParentFactory.Location, Location)))
    {
        if (bKeyVehicle)
            ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
        else
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
    }

    super(Vehicle).DriverLeft();
}

//Vehicle has been in the middle of nowhere with no driver for a while, so consider resetting it
//  called after ResetTime has passed since driver left
// Overriden so we can control the time it takes for the vehicle to disappear - Ramm
//
event CheckReset()
{
    local Pawn P;

    if (bKeyVehicle && IsVehicleEmpty())
    {
        Died(none, class'DamageType', Location);
        return;
    }

    if (!IsVehicleEmpty())
    {
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
        return;
    }

    foreach CollidingActors(class 'Pawn', P, 4000.0) //was 4000.0
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum())  //traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSize(P.Location - Location) < DriverTraceDist)) //was 2000 - server problems?
            {
               if (bDebuggingText)
               Level.Game.Broadcast(self, "Initiating Collision Reset Check...");

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
                return;
            }
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0,0,1), Location + CollisionHeight * vect(0,0,1)))
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Initiating FastTrace Reset Check...");

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
                return;
            }
        }
    }

    //if factory is active, we want it to spawn new vehicle NOW
    if (ParentFactory != none)
    {

        if (bDebuggingText)
        Level.Game.Broadcast(self, "Player not found.Respawn.");

        ParentFactory.VehicleDestroyed(self);
        ParentFactory.Timer();
        ParentFactory = none; //so doesn't call ParentFactory.VehicleDestroyed() again in Destroyed()
    }

    Destroy();
}

simulated state ViewTransition
{
    simulated function HandleTransition()
    {
         if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
         {
             if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
                 LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
         }

         //log("HandleTransition!");

         if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
         {
             SetTimer(GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim, 1.0), false);

             //log("HandleTransition Player Transition Up!");
                 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
         }
         else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
         {
             SetTimer(GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionDownAnim, 1.0), false);

             //log("HandleTransition Player Transition Down!");
                 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
         }

         if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
             Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
    }

    simulated function Timer()
    {
        SetTimer(1.0, false);
        GotoState('');
    }

    simulated function AnimEnd(int channel)
    {
        if (IsLocallyControlled())
            GotoState('');
    }

    simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            PlayerController(Controller).SetRotation(rot(0, 0, 0));
        }
    }

Begin:
    HandleTransition();
    Sleep(0.2);
}

function bool TryToDrive(Pawn P)
{
    local int x;

    if (DH_Pawn(P).bOnFire)
        return false;

    if (bOnFire || bEngineOnFire)
    {
        DenyEntry(P, 9);

        return false;
    }

    //don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (x = 0; x < WeaponPawns.length; x++)
            if (WeaponPawns[x].Driver != none)
            {
                DenyEntry(P, 2);
                return false;
            }
    }

    if (P.bIsCrouched || bNonHumanControl || (P.Controller == none) || (Driver != none) || (P.DrivenVehicle != none) || !P.Controller.bIsPlayer
         || P.IsA('Vehicle') || Health <= 0)
        return false;

    if (!Level.Game.CanEnterVehicle(self, P))
        return false;

    // Check vehicle Locking....
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {
        DenyEntry(P, 1);
        return false;
    }
    else if (bMustBeTankCommander && !ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew && P.IsHumanControlled())
    {
        //They mut be a non-tanker role so let's go through the available rider positions and find a place for them to sit.
        //Check first to ensure riders are allowed.
        if (!bAllowRiders)
        {
            DenyEntry(P, 3);
            return false;
        }

        //cycle through the available passenger positions.  Check the class type to see if it is ROPassengerPawn
        for (x = 1; x < WeaponPawns.length; x++)    //skip over the turret
        {
            //If riders are allowed, the WeaponPawn is free and it is a passenger pawn class then climb aboard.
            if (WeaponPawns[x].Driver == none && WeaponPawns[x].IsA('ROPassengerPawn'))
            {
                WeaponPawns[x].KDriverEnter(P);
                return true;
            }
        }

        DenyEntry(P, 8);
        return false;
    }
    else
    {
        if (bEnterringUnlocks && bTeamLocked)
            bTeamLocked = false;

        KDriverEnter(P);
        return true;
    }
}

// Send a message on why they can't get in the vehicle
function DenyEntry(Pawn P, int MessageNum)
{
    P.ReceiveLocalizedMessage(class'DH_VehicleMessage', MessageNum);
}

// Returns true if this tank is disabled
simulated function bool IsDisabled()
{
    return ((EngineHealth <= 0) || (bLeftTrackDamaged && bRightTrackDamaged));        //((EngineHealth <= 0) || bEngineOnFire);
}

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    //Engine starting and stopping stuff
    //bEngineOff=true;
    //bEngineDead=false;
    //bDisableThrottle=true;
    //bFirstHit=true;

    EngineHealth=EngineHealthMax;

    EngineFireDamagePerSec = EngineHealthMax * 0.10;  // Damage is dealt every 3 seconds, so this value is triple the intended per second amount
    DamagedEffectFireDamagePerSec = HealthMax * 0.02; //~100 seconds from regular tank fire threshold to detontation from full health, damage is every 2 seconds, so double intended
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (!bEngineOff)
        bEngineOff=false;

}

simulated function Tick(float DeltaTime)
{
    //local PlayerController PC;
    local float MotionSoundTemp;
    local KRigidBodyState BodyState;
    local float MySpeed;
    local int i;

    KGetRigidBodyState(BodyState);
    LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

    // Damaged treads cause vehicle to swerve and turn without control
    if (Controller != none)
    {
        if (bLeftTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.50, 0.50);
            if (Controller.IsA('ROPlayer'))
                ROPlayer(Controller).aStrafe = -32768;
            else if (Controller.IsA('ROBot'))
                Steering = 1;
        }
        else if (bRightTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.50, 0.50);
            if (Controller.IsA('ROPlayer'))
                ROPlayer(Controller).aStrafe = 32768;
            else if (Controller.IsA('ROBot'))
                Steering = -1;
        }
    }

    // Only need these effects client side
    if (Level.Netmode != NM_DedicatedServer)
    {
        if (bDisableThrottle)
        {
            if (bWantsToThrottle)
            {
                IntendedThrottle=1.0;
            }
            else if (IntendedThrottle > 0)
            {
                IntendedThrottle -= (DeltaTime * 0.5);
            }
            else
            {
                IntendedThrottle=0;
            }
        }
        else
        {
            if (bLeftTrackDamaged)
            {
                 if (LeftTreadSoundAttach.AmbientSound != TrackDamagedSound)
                    LeftTreadSoundAttach.AmbientSound = TrackDamagedSound;
                 LeftTreadSoundAttach.SoundVolume = IntendedThrottle * 255;
            }

            if (bRightTrackDamaged)
            {
                 if (RightTreadSoundAttach.AmbientSound != TrackDamagedSound)
                    RightTreadSoundAttach.AmbientSound = TrackDamagedSound;
                 RightTreadSoundAttach.SoundVolume = IntendedThrottle * 255;
            }

            SoundVolume = FMax(255 * 0.3,IntendedThrottle * 255);

            if (SoundVolume != default.SoundVolume)
            {
                SoundVolume = default.SoundVolume;
            }

            if (bLeftTrackDamaged && Skins[LeftTreadIndex] != DamagedTreadPanner)
                Skins[LeftTreadIndex]=DamagedTreadPanner;

            if (bRightTrackDamaged && Skins[RightTreadIndex] != DamagedTreadPanner)
                Skins[RightTreadIndex]=DamagedTreadPanner;

        }


        // Shame on you Psyonix, for calling VSize() 3 times every tick, when it only needed to be called once.
        // VSize() is very CPU intensive - Ramm
        MySpeed = VSize(Velocity);

        // Setup sounds that are dependent on velocity
        MotionSoundTemp =  MySpeed/MaxPitchSpeed * 255;
        if (MySpeed > 0.1)
        {
            MotionSoundVolume =  FClamp(MotionSoundTemp, 0, 255);
        }
        else
        {
            MotionSoundVolume=0;
        }
        UpdateMovementSound();

        //Level.Game.Broadcast(self, "MySpeed: "$MySpeed);

        if (LeftTreadPanner != none)
        {
            LeftTreadPanner.PanRate = MySpeed / TreadVelocityScale;
            if (Velocity dot vector(Rotation) < 0)
                LeftTreadPanner.PanRate = -1 * LeftTreadPanner.PanRate;
            LeftTreadPanner.PanRate += LinTurnSpeed;
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = MySpeed / TreadVelocityScale;
            if (Velocity dot vector(Rotation) < 0)
                RightTreadPanner.PanRate = -1 * RightTreadPanner.PanRate;
            RightTreadPanner.PanRate -= LinTurnSpeed;
        }

        // Animate the tank wheels
        LeftWheelRot.pitch += LeftTreadPanner.PanRate * WheelRotationScale;
        RightWheelRot.pitch += RightTreadPanner.PanRate * WheelRotationScale;

        for(i=0; i<LeftWheelBones.Length; i++)
        {
              SetBoneRotation(LeftWheelBones[i], LeftWheelRot);
        }

        for(i=0; i<RightWheelBones.Length; i++)
        {
              SetBoneRotation(RightWheelBones[i], RightWheelRot);
        }

        if (MySpeed >= MaxCriticalSpeed && Controller != none)
        {
            if (Controller.IsA('ROPlayer'))
                ROPlayer(Controller).aForward = -32768; //forces player to pull back on throttle
        }
    }

    // This will slow the tank way down when it tries to turn at high speeds
    if (ForwardVel > 0.0)
        WheelLatFrictionScale = InterpCurveEval(AddedLatFriction, ForwardVel);
    else
        WheelLatFrictionScale = default.WheelLatFrictionScale;

    if (bEngineOnFire || (bOnFire && Health > 0) && DamagedEffect != none)
    {
        if (DamagedEffectHealthFireFactor != 1.0)
        {
            DamagedEffectHealthFireFactor = 1.0;
            DamagedEffect.UpdateDamagedEffect(true, 0, false, false);
        }

        if (bOnFire && DriverHatchFireEffect == none)
        {
            // Lets randomise the fire start times to desync them with the turret and engine ones
            if (Level.TimeSeconds - DriverHatchBurnTime > 0.2)
            {
                if (FRand() < 0.1)
                {
                    DriverHatchFireEffect = Spawn(FireEffectClass);
                    AttachToBone(DriverHatchFireEffect, FireAttachBone);
                    DriverHatchFireEffect.SetRelativeLocation(FireEffectOffset);
                    DriverHatchFireEffect.SetEffectScale(DamagedEffectScale);
                    DriverHatchFireEffect.UpdateDamagedEffect(true, 0, false, false);
                }
                DriverHatchBurnTime = Level.TimeSeconds;
            }
            else if (!bTurretFireTriggered)
            {
                DH_ROTankCannon(WeaponPawns[0].Gun).bOnFire = true;
                bTurretFireTriggered = true;
            }
            else if (!bHullMGFireTriggered)
            {
                DH_ROMountedTankMG(WeaponPawns[1].Gun).bOnFire = true;
                bHullMGFireTriggered = true;
            }
        }

        TakeFireDamage(DeltaTime);
    }
    else if (EngineHealth <= 0 && Health > 0)
    {
        if (DamagedEffectHealthFireFactor != 0)
        {
            DamagedEffectHealthFireFactor = 0.0;
            DamagedEffectHealthHeavySmokeFactor = 1.0;
            DamagedEffect.UpdateDamagedEffect(false, 0, false, false); // reset fire effects
            DamagedEffect.UpdateDamagedEffect(false, 0, false, true);  // set the tank to smoke instead of burn
        }
    }

    super(ROWheeledVehicle).Tick(DeltaTime);

    if (bEngineDead || bEngineOff || (bLeftTrackDamaged && bRightTrackDamaged))
    {
        velocity=vect(0,0,0);
        Throttle=0;
        ThrottleAmount=0;
        bWantsToThrottle=false;
        bDisableThrottle=true;
        Steering=0;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        CheckEmitters();
    }
}

simulated function CheckEmitters()
{
    if (Level.NetMode == NM_DedicatedServer)
        return;

    if (bEmittersOn && (bEngineDead || bEngineOff))
        StopEmitters();
    else if (!bEmittersOn && !bEngineDead && !bEngineOff)
        StartEmitters();
}

// TakeFireDamage() called every tick when vehicle is burning
event TakeFireDamage(float DeltaTime)
{

    // Engine fire damage
    if (Level.TimeSeconds - EngineBurnTime > 3)
    {
        if (bEngineOnFire && EngineHealth > 0)
        {
            // If the instigator gets teamswapped before a burning tank dies, make sure they don't get friendly kills for it
            if (WhoSetEngineOnFire.GetTeamNum() != FireStarterTeam)
            {
                WhoSetEngineOnFire = none;
                DelayedDamageInstigatorController = none;
            }

            DamageEngine(EngineFireDamagePerSec, WhoSetEngineOnFire.Pawn, vect(0,0,0), vect(0,0,0), VehicleBurningDamType);
            EngineBurnTime = Level.TimeSeconds;
        }

        // Small chance of engine fire setting whole tank on fire, runs every time the fire does damage
        if (Level.TimeSeconds - FireCheckTime > 3 && !bOnFire && bEngineOnFire)
        {
            // If the instigator gets teamswapped before a burning tank dies, make sure they don't get friendly kills for it
            if (WhoSetOnFire.GetTeamNum() != FireStarterTeam)
            {
                 WhoSetOnFire = none;
                 DelayedDamageInstigatorController = none;
            }

            if (FRand() < EngineToHullFireChance)  // - was 2%
            {
                TakeDamage(DamagedEffectFireDamagePerSec, WhoSetOnFire.Pawn, vect(0,0,0), vect(0,0,0), VehicleBurningDamType); // This will set bOnFire the first time it runs
            }
            FireCheckTime = Level.TimeSeconds;
        }
    }

    // Engine fire dies down 30 seconds after engine health hits zero
    if (Level.TimeSeconds - EngineBurnTime > 30 && bEngineOnFire && !bOnFire)
    {
        bEngineOnFire=false;
        bDisableThrottle=true;
        bEngineDead=true;
        DH_ROTankCannon(WeaponPawns[0].Gun).bManualTurret = true;

        if (!bOnFire)
        {
            AmbientSound = SmokingEngineSound;
        }
    }

    // Hull fire damage
    if ((Level.TimeSeconds - BurnTime) > 2 && bOnFire)
    {
        // Lets avoid having the tank blow up the instant it's hit (i.e. the first run through the function)
        // as it gives the false impression that the hit itself was critical when it's not
        if (BurnTime == 0)
        {
            BurnTime = Level.TimeSeconds + 3;
            return;
        }

        // If the instigator gets teamswapped before a burning tank dies, make sure they don't get friendly kills for it
        if (WhoSetOnFire != none && WhoSetOnFire.GetTeamNum() != FireStarterTeam)
        {
            WhoSetOnFire = none;
            DelayedDamageInstigatorController = none;
        }

        if (Driver != none) //afflict the driver
        {
            Driver.TakeDamage(PlayerFireDamagePerSec, WhoSetOnFire.Pawn, Location, vect(0,0,0), VehicleBurningDamType);
        }
        else if (WeaponPawns[0] != none && WeaponPawns[0].Driver != none && bTurretFireTriggered == true) //afflict the commander
        {
            WeaponPawns[0].Driver.TakeDamage(PlayerFireDamagePerSec, WhoSetOnFire.Pawn, Location, vect(0,0,0), VehicleBurningDamType);
        }
        else if (WeaponPawns[1] != none && WeaponPawns[1].Driver != none && bHullMGFireTriggered == true) //afflict the hull gunner
        {
            WeaponPawns[1].Driver.TakeDamage(PlayerFireDamagePerSec, WhoSetOnFire.Pawn, Location, vect(0,0,0), VehicleBurningDamType);
        }

        if (FRand() < FireDetonationChance) // Chance of cooking off ammo/igniting fuel before health runs out
        {
            TakeDamage(Health, WhoSetOnFire.Pawn, vect(0,0,0), vect(0,0,0), VehicleBurningDamType);
        }
        else
            TakeDamage(DamagedEffectFireDamagePerSec, WhoSetOnFire.Pawn, vect(0,0,0), vect(0,0,0), VehicleBurningDamType);

        BurnTime = Level.TimeSeconds;
    }
}

function DamageTrack(bool bLeftTrack)
{
    if (bLeftTrack)
    {
        bDisableThrottle=false;
        bLeftTrackDamaged=true;
    }
    else
    {
        bDisableThrottle=false;
        bRightTrackDamaged=true;
    }
}

// Check to see if something hit a certain Hitpoint
function bool IsNewPointShot(vector loc, vector ray, float AdditionalScale, int index)
{
    local coords C;
    local vector HeadLoc, B, M, diff;
    local float t, DotMM, Distance;

    if (NewVehHitpoints[index].PointBone == '')
        return false;

    C = GetBoneCoords(NewVehHitpoints[index].PointBone);

    HeadLoc = C.Origin + (NewVehHitpoints[index].PointHeight * NewVehHitpoints[index].PointScale * AdditionalScale * C.XAxis);

    HeadLoc = HeadLoc + (NewVehHitpoints[index].PointOffset >> Rotator(C.Xaxis));

    // Express snipe trace line in terms of B + tM
    B = loc;
    M = ray * 150;

    // Find Point-Line Squared Distance
    diff = HeadLoc - B;
    t = M dot diff;
    if (t > 0)
    {
        DotMM = M dot M;
        if (t < DotMM)
        {
            t = t / DotMM;
            diff = diff - (t * M);
        }
        else
        {
            t = 1;
            diff -= M;
        }
    }
    else
        t = 0;

    Distance = Sqrt(diff Dot diff);

    return (Distance < (NewVehHitpoints[index].PointRadius * NewVehHitpoints[index].PointScale * AdditionalScale));
}

//DH Code: Return the compound hit angle
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    local float CompoundAngle;

    // convert the angle degrees to radians
    AOI = abs(AOI * 0.01745329252);
    ArmorSlopeDegrees = abs(ArmorSlopeDegrees * 0.01745329252);

    CompoundAngle = Acos(Cos(ArmorSlopeDegrees)*Cos(AOI));

    return CompoundAngle;
}

//DH CODE: Returns (T/d) for APC/APCBC shells
simulated function float GetOverMatch(float ArmorFactor, float ShellDiameter)
{
    local float OverMatchFactor;

    OverMatchFactor = (ArmorFactor / ShellDiameter);

    return OverMatchFactor;

}

//DH CODE: Calculate APC/APCBC penetration
simulated function bool PenetrationAPC(float ArmorFactor, float CompoundAngle, float PenetrationNumber, float OverMatchFactor, bool bShatterProne)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float SlopeMultiplier;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;
    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //After Bird & Livingston
    DHArmorSlopeTable[0]= 1.01 * (OverMatchFactor**0.0225);  //10
    DHArmorSlopeTable[1]= 1.03 * (OverMatchFactor**0.0327);  //15
    DHArmorSlopeTable[2]= 1.10 * (OverMatchFactor**0.0454);  //20
    DHArmorSlopeTable[3]= 1.17 * (OverMatchFactor**0.0549);  //25
    DHArmorSlopeTable[4]= 1.27 * (OverMatchFactor**0.0655);  //30
    DHArmorSlopeTable[5]= 1.39 * (OverMatchFactor**0.0993);  //35
    DHArmorSlopeTable[6]= 1.54 * (OverMatchFactor**0.1388);  //40
    DHArmorSlopeTable[7]= 1.72 * (OverMatchFactor**0.1655);  //45
    DHArmorSlopeTable[8]= 1.94 * (OverMatchFactor**0.2035);  //50
    DHArmorSlopeTable[9]= 2.12 * (OverMatchFactor**0.2427);  //55
    DHArmorSlopeTable[10]= 2.56 * (OverMatchFactor**0.2450); //60
    DHArmorSlopeTable[11]= 3.20 * (OverMatchFactor**0.3354); //65
    DHArmorSlopeTable[12]= 3.98 * (OverMatchFactor**0.3478); //70
    DHArmorSlopeTable[13]= 5.17 * (OverMatchFactor**0.3831); //75
    DHArmorSlopeTable[14]= 8.09 * (OverMatchFactor**0.4131); //80
    DHArmorSlopeTable[15]= 11.32 * (OverMatchFactor**0.4550); //85

    //SlopeMultiplier calcs - using linear interpolation
    if      (CompoundAngleDegrees < 10)  SlopeMultiplier = (DHArmorSlopeTable[0] + (10 - CompoundAngleDegrees) * (DHArmorSlopeTable[0]-DHArmorSlopeTable[1]) / 10);
    else if (CompoundAngleDegrees < 15)  SlopeMultiplier = (DHArmorSlopeTable[1] + (15 - CompoundAngleDegrees) * (DHArmorSlopeTable[0]-DHArmorSlopeTable[1]) / 5);
    else if (CompoundAngleDegrees < 20)  SlopeMultiplier = (DHArmorSlopeTable[2] + (20 - CompoundAngleDegrees) * (DHArmorSlopeTable[1]-DHArmorSlopeTable[2]) / 5);
    else if (CompoundAngleDegrees < 25)  SlopeMultiplier = (DHArmorSlopeTable[3] + (25 - CompoundAngleDegrees) * (DHArmorSlopeTable[2]-DHArmorSlopeTable[3]) / 5);
    else if (CompoundAngleDegrees < 30)  SlopeMultiplier = (DHArmorSlopeTable[4] + (30 - CompoundAngleDegrees) * (DHArmorSlopeTable[3]-DHArmorSlopeTable[4]) / 5);
    else if (CompoundAngleDegrees < 35)  SlopeMultiplier = (DHArmorSlopeTable[5] + (35 - CompoundAngleDegrees) * (DHArmorSlopeTable[4]-DHArmorSlopeTable[5]) / 5);
    else if (CompoundAngleDegrees < 40)  SlopeMultiplier = (DHArmorSlopeTable[6] + (40 - CompoundAngleDegrees) * (DHArmorSlopeTable[5]-DHArmorSlopeTable[6]) / 5);
    else if (CompoundAngleDegrees < 45)  SlopeMultiplier = (DHArmorSlopeTable[7] + (45 - CompoundAngleDegrees) * (DHArmorSlopeTable[6]-DHArmorSlopeTable[7]) / 5);
    else if (CompoundAngleDegrees < 50)  SlopeMultiplier = (DHArmorSlopeTable[8] + (50 - CompoundAngleDegrees) * (DHArmorSlopeTable[7]-DHArmorSlopeTable[8]) / 5);
    else if (CompoundAngleDegrees < 55)  SlopeMultiplier = (DHArmorSlopeTable[9] + (55 - CompoundAngleDegrees) * (DHArmorSlopeTable[8]-DHArmorSlopeTable[9]) / 5);
    else if (CompoundAngleDegrees < 60)  SlopeMultiplier = (DHArmorSlopeTable[10] + (60 - CompoundAngleDegrees) * (DHArmorSlopeTable[9]-DHArmorSlopeTable[10]) / 5);
    else if (CompoundAngleDegrees < 65)  SlopeMultiplier = (DHArmorSlopeTable[11] + (65 - CompoundAngleDegrees) * (DHArmorSlopeTable[10]-DHArmorSlopeTable[11]) / 5);
    else if (CompoundAngleDegrees < 70)  SlopeMultiplier = (DHArmorSlopeTable[12] + (70 - CompoundAngleDegrees) * (DHArmorSlopeTable[11]-DHArmorSlopeTable[12]) / 5);
    else if (CompoundAngleDegrees < 75)  SlopeMultiplier = (DHArmorSlopeTable[13] + (75 - CompoundAngleDegrees) * (DHArmorSlopeTable[12]-DHArmorSlopeTable[13]) / 5);
    else if (CompoundAngleDegrees < 80)  SlopeMultiplier = (DHArmorSlopeTable[14] + (80 - CompoundAngleDegrees) * (DHArmorSlopeTable[13]-DHArmorSlopeTable[14]) / 5);
    else if (CompoundAngleDegrees < 85)  SlopeMultiplier = (DHArmorSlopeTable[15] + (85 - CompoundAngleDegrees) * (DHArmorSlopeTable[14]-DHArmorSlopeTable[15]) / 5);
    else SlopeMultiplier = DHArmorSlopeTable[15];

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "SlopeMultiplier: "$SlopeMultiplier);
    }

    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne && OverMatchFactor > 0.8)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.06) || PenetrationRatio > 1.19)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19) //shatter gap
        {
            bRoundShattered=true;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HVAP penetration
simulated function bool PenetrationHVAP(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //New EffectiveArmor calcs
    if (CompoundAngleDegrees <= 25)
    {
       CompoundExp = CompoundAngleDegrees**2.2;
       EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.0001727)));
    }
    else
    {
       CompoundExp = CompoundAngleDegrees**1.5;
       EffectiveArmor = (ArmorFactor * 0.7277 * (2.71828 ** (CompoundExp * 0.003787)));
    }

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.10) || PenetrationRatio > 1.34)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.34)
        {
            bRoundShattered=true;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HVAP penetration - 90mm
simulated function bool PenetrationHVAPLarge(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //New EffectiveArmor calcs
    if (CompoundAngleDegrees <= 30)
    {
       CompoundExp = CompoundAngleDegrees**1.75;
       EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.000662)));
    }
    else
    {
       CompoundExp = CompoundAngleDegrees**2.2;
       EffectiveArmor = (ArmorFactor * 0.9043 * (2.71828 ** (CompoundExp * 0.0001987)));
    }

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.10) || PenetrationRatio > 1.27)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.27)
        {
            bRoundShattered=true;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate APDS penetration
simulated function bool PenetrationAPDS(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;
    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    CompoundExp = CompoundAngleDegrees ** 2.6;

    //New EffectiveArmor calcs
    EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.00003011)));

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Angle: "$CompoundAngleDegrees$"degrees, Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.06) || PenetrationRatio > 1.20)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.20)
        {
            bRoundShattered=true;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HEAT penetration
simulated function bool PenetrationHEAT(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bIsHEATRound)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundAngleFixed;
    local float SlopeMultiplier;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //convert angle back to radians
    CompoundAngleFixed = abs(CompoundAngleDegrees * 0.01745329252);

    //calculate the slope
    SlopeMultiplier = 1 / Cos(CompoundAngleFixed);

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "SlopeMultiplier: "$SlopeMultiplier);
    }

    EffectiveArmor = ArmorFactor * SlopeMultiplier;

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bIsHEATRound)
       bWasHEATRound = true;

    if (PenetrationRatio >= 1.0)
    {
        bProjectilePenetrated = true; //to determine if interior damage is done
        return true;
    }
    else
    {
        bProjectilePenetrated = false;
        return false;
    }
}

simulated function bool DHShouldPenetrateAPC(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, float ShellDiameter, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;

    if (bAssaultWeaponHit) //Big fat HACK to defeat Stug/JP bug
    {
       bAssaultWeaponHit=false;
       return PenetrationAPC(GunMantletArmorFactor, GetCompoundAngle(InAngleDegrees, GunMantletSlope), PenetrationNumber, GetOverMatch(GunMantletArmorFactor, ShellDiameter), bShatterProne);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    //if (bDebuggingText && Role == ROLE_Authority)
    //Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
            }

               //Run a pre-check
            if (URearArmorFactor > PenetrationNumber)
                return false;

            bRearHit=true;

            return PenetrationAPC(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, GetOverMatch(URearArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (UFrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, GetOverMatch(UFrontArmorFactor, ShellDiameter), bShatterProne);

    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Left side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, GetOverMatch(URightArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor "$ULeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (ULeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, GetOverMatch(ULeftArmorFactor, ShellDiameter), bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (UFrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, GetOverMatch(UFrontArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URearArmorFactor > PenetrationNumber)
            return false;

        bRearHit=true;

        return PenetrationAPC(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, GetOverMatch(URearArmorFactor, ShellDiameter), bShatterProne);


    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Right
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor = "$ULeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (ULeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, GetOverMatch(ULeftArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, GetOverMatch(URightArmorFactor, ShellDiameter), bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHVAP(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;

    if (bAssaultWeaponHit) //Big fat HACK to defeat Stug/JP bug
    {
       bAssaultWeaponHit=false;
       return PenetrationHVAP(GunMantletArmorFactor, GetCompoundAngle(InAngleDegrees, GunMantletSlope), PenetrationNumber, bShatterProne);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

           if (bPenetrationText && Role == ROLE_Authority)
           {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
           }

            //Run a pre-check
            if (URearArmorFactor > PenetrationNumber)
                return false;

            bRearHit=true;

            return PenetrationHVAP(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (UFrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Left side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor "$ULeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (ULeftArmorFactor > PenetrationNumber)
                return false;

        return PenetrationHVAP(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (UFrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URearArmorFactor > PenetrationNumber)
            return false;

        bRearHit=true;

        return PenetrationHVAP(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);


    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Right
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor = "$ULeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (ULeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHVAPLarge(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;

    if (bAssaultWeaponHit) //Big fat HACK to defeat Stug/JP bug
    {
       bAssaultWeaponHit=false;
       return PenetrationHVAPLarge(GunMantletArmorFactor, GetCompoundAngle(InAngleDegrees, GunMantletSlope), PenetrationNumber, bShatterProne);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

           if (bPenetrationText && Role == ROLE_Authority)
           {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
           }

            //Run a pre-check
            if (URearArmorFactor > PenetrationNumber)
                return false;

            bRearHit=true;

            return PenetrationHVAPLarge(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (UFrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Left side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor "$ULeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (ULeftArmorFactor > PenetrationNumber)
                return false;

        return PenetrationHVAPLarge(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (UFrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URearArmorFactor > PenetrationNumber)
            return false;

        bRearHit=true;

        return PenetrationHVAPLarge(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);


    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Right
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
        Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor = "$ULeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (ULeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}


simulated function bool DHShouldPenetrateAPDS(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;

    if (bAssaultWeaponHit) //Big fat HACK to defeat Stug/JP bug
    {
       bAssaultWeaponHit=false;
       return PenetrationAPDS(GunMantletArmorFactor, GetCompoundAngle(InAngleDegrees, GunMantletSlope), PenetrationNumber, bShatterProne);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URearArmorFactor > PenetrationNumber)
            {
                return false;
            }

            bRearHit=true;

            return PenetrationAPDS(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (UFrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Left side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor "$ULeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (ULeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
            }

                    //Run a pre-check
            if (UFrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URearArmorFactor > PenetrationNumber)
            return false;

        bRearHit=true;

        return PenetrationAPDS(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Right
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor = "$ULeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (ULeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHEAT(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bIsHEATRound)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;

    if (bAssaultWeaponHit) //Big fat HACK to defeat Stug/JP bug
    {
       bAssaultWeaponHit=false;
       return PenetrationHEAT(GunMantletArmorFactor, GetCompoundAngle(InAngleDegrees, GunMantletSlope), PenetrationNumber, bIsHEATRound);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URearArmorFactor > PenetrationNumber)
                return false;

            bRearHit=true;

            return PenetrationHEAT(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (UFrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bIsHEATRound);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Left side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (URightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor "$ULeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (ULeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bIsHEATRound);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, VehicleNameString$" front hull hit, base armor = "$UFrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (UFrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(UFrontArmorFactor, GetCompoundAngle(InAngleDegrees, UFrontArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" rear hull hit, base armor = "$URearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URearArmorFactor > PenetrationNumber)
            return false;

        bRearHit=true;

        return PenetrationHEAT(URearArmorFactor, GetCompoundAngle(InAngleDegrees, URearArmorSlope), PenetrationNumber, bIsHEATRound);
    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Right
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        HitDir = Hitlocation - Location;

        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (bDebugTreadText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "InAngle: "$InAngle$"degrees");
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, VehicleNameString$" left hull hit, base armor = "$ULeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (ULeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(ULeftArmorFactor, GetCompoundAngle(InAngleDegrees, ULeftArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, VehicleNameString$" right hull hit, base armor = "$URightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (URightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(URightArmorFactor, GetCompoundAngle(InAngleDegrees, URightArmorSlope), PenetrationNumber, bIsHEATRound);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}


// TakeDamage - overloaded to prevent bayonet and bash attacks from damaging vehicles
//              for Tanks, we'll probably want to prevent bullets from doing damage too
function TakeDamage(int Damage, Pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{

    local vector LocDir, HitDir;
    local float HitAngle,Side, InAngle;
    local vector X,Y,Z;
    local int i;
    local float VehicleDamageMod;
    local int HitPointDamage;
    local int InstigatorTeam;
    local controller InstigatorController;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (instigatedBy == self && DamageType != VehicleBurningDamType)
        return;

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to thier team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
            InstigatorController = instigatedBy.Controller;

        if (InstigatorController == none)
        {
            if (DamageType.default.bDelayedDamage)
                InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if ((GetTeamNum() != 255) && (InstigatorTeam != 255))
            {
                if (GetTeamNum() == InstigatorTeam)
                {
                    return;
                }
            }
        }
    }


    // Modify the damage based on what it should do to the vehicle; overloaded here so tank cannot take any bullet/bash/bayo damage
    if (DamageType != none)
    {
       if (class<ROWeaponDamageType>(DamageType) != none)
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.TankDamageModifier;
       else if (class<ROVehicleDamageType>(DamageType) != none)
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.TankDamageModifier;
    }

    for(i=0; i<VehHitpoints.Length; i++)
    {
        HitPointDamage=Damage;

        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (    class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i))
                {
                    //Level.Game.Broadcast(self, "Hit Driver"); //re-comment when fixed
                    Driver.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    //Level.Game.Broadcast(self, "Hit Driver");  //re-comment when fixed
                    Driver.TakeDamage(150, instigatedBy, Hitlocation, Momentum, damageType); //just kill the bloody driver
                }
            }
        }
        else if (IsPointShot(Hitlocation,Momentum, 1.0, i))
        {
            HitPointDamage *= VehHitpoints[i].DamageMultiplier;
            HitPointDamage *= VehicleDamageMod;

            if (bLogPenetration)
                log(" We hit "$GetEnum(enum'EHitPointType',VehHitpoints[i].HitPointType)$" hitpoint.");


            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                //extra check here prevents splashing HE/HEAT from triggering engine fires
                if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && bProjectilePenetrated == true)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Engine Hit Effective");
                    DamageEngine(HitPointDamage, instigatedBy, Hitlocation, Momentum, damageType);
                    Damage *= 0.55; //hitting the engine shouldn't blow up the tank automatically!
                }
            }
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                if (bProjectilePenetrated == true && bRearHit == false)  //extra check here prevents splashing HE/HEAT from triggering ammo detonation or fires; Engine hit will stop shell from passing through to cabin
                {
                    if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && FRand() <= AmmoIgnitionProbability || (bWasHEATRound && FRand() < 0.85))
                    {
                       if (bDebuggingText)
                       Level.Game.Broadcast(self, "Ammo Hit Effective");
                       Damage *= Health;//VehHitpoints[i].DamageMultiplier;
                       break;
                    }
                    else  //either detonate above - or - set the sucker on fire!
                    {
                       HullFireChance=0.75;
                       HullFireHEATChance=0.90; //
                    }
                }
            }
        }
    }
    for(i=0; i<NewVehHitpoints.Length; i++)
    {
        HitPointDamage=Damage;

        if (bLogPenetration)
          log(" We hit "$GetEnum(enum'ENewHitPointType',NewVehHitpoints[i].NewHitPointType)$" hitpoint.");

        if (IsNewPointShot(Hitlocation,Momentum, 1.0, i))
        {
            HitPointDamage *= VehicleDamageMod;

            if  (NewVehHitpoints[i].NewHitPointType == NHP_GunOptics) //can be useful for Stug and JP
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Optics Hit");
                DH_ROTankCannonPawn(WeaponPawns[0]).DamageCannonOverlay();
            }
            else if (NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
            {
            }
            else if (NewVehHitpoints[i].NewHitPointType == NHP_Traverse && bProjectilePenetrated == true) //useful for assault guns
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Turret ring hit");
                DH_ROTankCannonPawn(WeaponPawns[0]).bTurretRingDamaged = true;
            }
            else if (NewVehHitpoints[i].NewHitPointType == NHP_GunPitch && bProjectilePenetrated == true) //useful for assault guns
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Gun pivot hit");

                DH_ROTankCannonPawn(WeaponPawns[0]).bGunPivotDamaged = true;
            }
        }
    }

    if (bProjectilePenetrated == true)
    {
        if (bWasTurretHit == false)
        {
            if (bRearHit == false && Driver != none && FRand() < Damage/DriverKillChance)
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Driver killed");
                Driver.TakeDamage(150, instigatedBy, Location, vect(0,0,0), DamageType);
            }

            if (bRearHit == false && WeaponPawns[1] != none && WeaponPawns[1].Driver != none && FRand() < Damage/GunnerKillChance)
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Hull Gunner killed");
                WeaponPawns[1].Driver.TakeDamage(150, instigatedBy, Location, vect(0,0,0), DamageType);
            }
        }
        else
        {
            if (WeaponPawns[0] != none)
            {
                if (WeaponPawns[0].Driver != none && FRand() < Damage/CommanderKillChance)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Commander killed");
                    WeaponPawns[0].Driver.TakeDamage(150, instigatedBy, Location, vect(0,0,0), DamageType);
                }

                if (FRand() < Damage/OpticsDamageChance)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Optics Destroyed");
                    DH_ROTankCannonPawn(WeaponPawns[0]).DamageCannonOverlay();
                }

                if (FRand() < Damage/GunDamageChance)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Gun Pivot Damaged");
                    DH_ROTankCannonPawn(WeaponPawns[0]).bGunPivotDamaged = true;
                }

                if (FRand() < Damage/TraverseDamageChance)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Traverse Damaged");
                    DH_ROTankCannonPawn(WeaponPawns[0]).bTurretRingDamaged = true;
                }
            }

            if (FRand() < Damage/TurretDetonationThreshold)
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Turret Ammo Detonated");
                Damage *= Health;
            }
            else
            {
                Damage *= 0.55; //0.35 in version 5.0
            }
        }

        if (!bFirstHit)
        {
            HullFireChance=0.75;
            HullFireHEATChance=0.90; //
        }
    }

    //Tread damage calculations
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;

    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    if (side >= 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    if ((HitAngle >= FrontRightAngle && Hitangle < RearRightAngle) && !bWasTurretHit) //Left side hit
    {
        HitDir = Hitlocation - Location;
        InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (InAngle > TreadHitMinAngle)
        {
            if (DamageType != none && class<ROWeaponDamageType>(DamageType) != none &&
            class<ROWeaponDamageType>(DamageType).default.TreadDamageModifier >= TreadDamageThreshold)
            {
               if (!bDriving)
                Enable('Tick');

                DamageTrack(true);
                //ShowTreadDamage();
                if (bDebugTreadText && Role == ROLE_Authority)
                Level.Game.Broadcast(self, "Left track damaged");
            }
        }
    }
    else if ((HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle) && !bWasTurretHit)  //Right side hit
    {

       HitDir = Hitlocation - Location;
       InAngle= Acos(Normal(HitDir) dot Normal(Z));

        if (InAngle > TreadHitMinAngle)
        {
            if (DamageType != none && class<ROWeaponDamageType>(DamageType) != none &&
            class<ROWeaponDamageType>(DamageType).default.TreadDamageModifier >= TreadDamageThreshold)
            {
               if (!bDriving)
                Enable('Tick');

                DamageTrack(false);
                //ShowTreadDamage();
                if (bDebugTreadText && Role == ROLE_Authority)
                Level.Game.Broadcast(self, "Right track damaged");
            }
        }
    }

    // If I allow randomised damage then things break once the hull catches fire
    if (DamageType != VehicleBurningDamType)
        Damage *= RandRange(0.75, 1.08);

    // Add in the Vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);

    //This starts the hull fire; extra check added below to prevent HE splash from triggering Hull Fire Chance function
    if (!bOnFire && Damage > 0 && Health > 0 && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.50) && bProjectilePenetrated == true)
    {
        if ((DamageType != VehicleBurningDamType && FRand() < HullFireChance) || (bWasHEATRound && FRand() < HullFireHEATChance))
        {
            if (bDebuggingText)
              Level.Game.Broadcast(self, "Vehicle on Fire");

            if (!bDriving)
                Enable('Tick');

            bOnFire = true;
            WhoSetOnFire = instigatedBy.Controller;
            DelayedDamageInstigatorController = WhoSetOnFire;
            FireStarterTeam = WhoSetOnFire.GetTeamNum();
        }
        else if (DamageType == VehicleBurningDamType)
        {
            bOnFire = true;
            WhoSetOnFire = WhoSetEngineOnFire;
            FireStarterTeam = WhoSetOnFire.GetTeamNum();
        }
    }

    //reset everything
    bWasHEATRound=false;
    bRearHit=false;
    bFirstHit=false;
    bProjectilePenetrated=false;
    bWasShatterProne=false;
    bRoundShattered=false;
    bWasTurretHit=false;
}

// Handle the Engine Damage
function DamageEngine(int Damage, Pawn instigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType)
{
    local int actualDamage;

    if (DamageType != VehicleBurningDamType)
        actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
    else
        actualDamage = Damage;

    EngineHealth -= actualDamage;

    //This indicates chances for an Engine fire breaking out
    if (DamageType != VehicleBurningDamType && !bEngineOnFire && actualDamage > 0 && EngineHealth > 0 && Health > 0)
    {
        if ((bWasHEATRound && FRand() < EngineFireHEATChance) || FRand() < EngineFireChance)
        {
            if (bDebuggingText)
              Level.Game.Broadcast(self, "Engine on Fire");

            bEngineOnFire = true;
            WhoSetEngineOnFire = instigatedBy.Controller;
            DelayedDamageInstigatorController = WhoSetEngineOnFire;
            FireStarterTeam = WhoSetEngineOnFire.GetTeamNum();
        }
    }

    // If engine health drops below a certain level, slow the tank way down...
    if (EngineHealth > 0 && EngineHealth <= (EngineHealthMax * 0.50))
    {
        Throttle = FClamp(Throttle, -0.50, 0.50);
    }
    else if (EngineHealth <= 0)
    {
        if (bDebuggingText && Role == ROLE_Authority)
            Level.Game.Broadcast(self, "Engine is Dead");

        bDisableThrottle=true;
        bEngineOff=true;
        bEngineDead=true;
        DH_ROTankCannon(WeaponPawns[0].Gun).bManualTurret = true;

        TurnDamping = 0.0;

        IdleSound=VehicleBurningSound;
        StartUpSound=none;
        ShutDownSound=none;
        AmbientSound=VehicleBurningSound;
        SoundVolume=255;
        SoundRadius=600;
    }

}


// Check to see if vehicle should destroy itself
// Stops vehicle from premature detonation when on fire
function MaybeDestroyVehicle()
{
    if (IsDisabled() && IsVehicleEmpty() && !bNeverReset && !bOnFire && !bEngineOnFire)
    {
        bSpikedVehicle = true;
        SetTimer(VehicleSpikeTime, false);

        if (bDebuggingText)
        Level.Game.Broadcast(self, "Initiating SpikeTimer");

    }
}

simulated function Destroyed()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DriverHatchFireEffect != none)
        {
            DriverHatchFireEffect.Destroy();
            DriverHatchFireEffect = none;
        }
    }

    super.Destroyed();
}

simulated event DestroyAppearance()
{
    local int i;
    local KarmaParams KP;

    // For replication
    bDestroyAppearance = true;

    // Put brakes on
    Throttle    = 0;
    Steering    = 0;
    Rise        = 0;

    // Destroy the weapons
    if (Role == ROLE_Authority)
    {
        for(i=0;i<Weapons.Length;i++)
        {
            if (Weapons[i] != none)
                Weapons[i].Destroy();
        }
        for(i=0;i<WeaponPawns.Length;i++)
            WeaponPawns[i].Destroy();
    }
    Weapons.Length = 0;
    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        bNoTeamBeacon = true;

        for(i=0;i<HeadlightCorona.Length;i++)
            HeadlightCorona[i].Destroy();
        HeadlightCorona.Length = 0;

        if (HeadlightProjector != none)
            HeadlightProjector.Destroy();

        for(i=0; i<Dust.Length; i++)
        {
            if (Dust[i] != none)
                Dust[i].Kill();
        }

        Dust.Length = 0;

        for(i=0; i<ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    // Copy linear velocity from actor so it doesn't just stop.
    KP = KarmaParams(KParams);
    if (KP != none)
        KP.KStartLinVel = Velocity;

    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    if (DriverHatchFireEffect != none)
    {
        DriverHatchFireEffect.Kill();
    }

    // Become the dead vehicle mesh
    SetPhysics(PHYS_none);
    KSetBlockKarma(false);
    SetDrawType(DT_StaticMesh);
    SetStaticMesh(DestroyedVehicleMesh);
    KSetBlockKarma(true);
    SetPhysics(PHYS_Karma);
    Skins.length = 0;
    NetPriority = 2;
}

function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float RandomExplModifier;

    RandomExplModifier = FRand();

    // Don't hurt us when we are destroying our own vehicle // borrowed from AB
    // if (!bSpikedVehicle)
    HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);

    AmbientSound = DestroyedBurningSound; // test
    SoundVolume = 255.0;
    SoundRadius = 600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
            ClientVehicleExplosion(false);

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1;
        KAddImpulse(LinearImpulse, vect(0,0,0));
        KAddAngularImpulse(AngularImpulse);
    }
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
        return;

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    if (F >= FirstPassengerWeaponPawnIndex && bMustBeUnbuttonedToBecomePassenger && DriverPositionIndex >= UnbuttonedPositionIndex)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // "You must unbutton the hatch to exit."

        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Modified to optimise & to avoid accessed none errors
simulated function UpdateTurretReferences()
{
    local int i;

    for (i = 0; i < WeaponPawns.Length; i++)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Gun != none)
        {
            if (CannonTurret == none && WeaponPawns[i].Gun.IsA('ROTankCannon'))
            {
                CannonTurret = ROTankCannon(WeaponPawns[i].Gun);
            }
            else if (HullMG == none && WeaponPawns[i].Gun.IsA('ROMountedTankMG'))
            {
                HullMG = WeaponPawns[i].Gun;
            }

            if (CannonTurret != none && HullMG != none)
            {
                break;
            }
        }
    }
}

// Modified to add WeaponPawns != none check to avoid "accessed none" errors, now rider pawns won't exist on client unless occupied
simulated function int NumPassengers()
{
    local  int  i, num;

    if (Driver != none)
    {
        num = 1;
    }

    for (i = 0; i < WeaponPawns.length; i++)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
        {
            num++;
        }
    }

    return num;
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: allows debugging exit positions to be toggled for all DH_ROTreadCrafts
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROTreadCraft'.default.bDebugExitPositions = !class'DH_ROTreadCraft'.default.bDebugExitPositions;
        log("DH_ROTreadCraft.bDebugExitPositions =" @ class'DH_ROTreadCraft'.default.bDebugExitPositions);
    }
}

defaultproperties
{
     bEnterringUnlocks=false
     bAllowRiders=true
     UnbuttonedPositionIndex=2
     DamagedTreadPanner=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
     LeftTreadIndex=1
     RightTreadIndex=2
     MaxCriticalSpeed=700.000000
     AmmoIgnitionProbability=0.750000
     TreadDamageThreshold=0.500000
     DriverKillChance=1150.000000
     GunnerKillChance=1150.000000
     CommanderKillChance=950.000000
     OpticsDamageChance=3000.000000
     GunDamageChance=1250.000000
     TraverseDamageChance=2000.000000
     TurretDetonationThreshold=1750.000000
     FireAttachBone="driver_player"
     FireEffectOffset=(Z=-10.000000)
     EngineFireChance=0.500000
     EngineFireHEATChance=0.850000
     HullFireChance=0.250000
     HullFireHEATChance=0.500000
     VehicleBurningDamType=class'DH_VehicleBurningDamType'
     PlayerFireDamagePerSec=15.000000
     bFirstHit=true
     FireDetonationChance=0.070000
     EngineToHullFireChance=0.050000
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
     DamagedPeriscopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Destroyed'
     VehicleBurningSound=Sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
     DestroyedBurningSound=Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
     DamagedStartUpSound=Sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
     DamagedShutDownSound=Sound'DH_AlliedVehicleSounds2.Damaged.engine_stop_damaged'
     SmokingEngineSound=Sound'Amb_Constructions.steam.Krasnyi_Steam_Deep'
     FireEffectClass=class'ROEngine.VehicleDamagedEffect'
     EngineHealthMax=300
     bEngineOff=true
     DriverTraceDist=4500.000000
     GunMantletArmorFactor=10.000000
     GunMantletSlope=10.000000
     WaitForCrewTime=7.000000
     ChassisTorqueScale=0.900000
     ChangeUpPoint=2050.000000
     ChangeDownPoint=1100.000000
     ViewShakeRadius=50.000000
     ViewShakeOffsetMag=(X=0.000000,Z=0.000000)
     ViewShakeOffsetFreq=0.000000
     ExplosionSoundRadius=1000.000000
     ExplosionDamage=575.000000
     ExplosionRadius=900.000000
     DamagedEffectHealthSmokeFactor=0.850000
     DamagedEffectHealthMediumSmokeFactor=0.650000
     DamagedEffectHealthHeavySmokeFactor=0.350000
     DamagedEffectHealthFireFactor=0.000000
     TimeTilDissapear=90.000000
     IdleTimeBeforeReset=200.000000
     VehicleSpikeTime=60.000000
     EngineHealth=300
     bMustBeUnbuttonedToBecomePassenger=true
     FirstPassengerWeaponPawnIndex=255
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicleWeapon extends ROVehicleWeapon
    abstract;

const RAD2DEG = 57.29577951;
const DEG2RAD = 0.01745329;

var     DHMortarVehicleWeaponPawn   MortarPawn; // just a reference to the mortar pawn actor, for convenience & to avoid casts

// Trajectory
var     float           NewElevation;
var     float           Elevation;
var     float           ElevationMaximum;
var     float           ElevationMinimum;
var     float           ElevationStride;

// Firing & effects
var     name            MuzzleBoneName;
var     float           SpreadYawMin;
var     float           SpreadYawMax;
var     class<Emitter>  FireEmitterClass;
var     sound           FireSound;
var  class<Projectile>  PendingProjectileClass; // from ROTankCannon

// Debugging
var     bool            bDebug;
var     bool            bDebugNoSpread;
var     bool            bDebugCalibrate;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        PendingProjectileClass;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ClientReplicateElevation;
}

// Added in 5.1 to replace constantly sending Elevate() & Depress() calls to server and sending Elevation variable to owning client
// Client calls this function to update server's elevation setting at specific times such as firing or leaving the mortar
// Exploitation would be completely benign and pointless - Basnett
simulated function ClientReplicateElevation(float NewElevation)
{
    if (bDebug && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, Role @ "ClientReplicateElevation" @ NewElevation);
    }

    Elevation = NewElevation;
}

// Modified to initialize ammo
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PendingProjectileClass = PrimaryProjectileClass;

    MainAmmoCharge[0] = 0;
    MainAmmoCharge[1] = 0;
}

// Matt: new function to do any extra set up in the mortar classes (called from mortar pawn) - can be subclassed to do any weapon specific setup
// Crucially, we know that we have MortarPawn & its VehicleBase when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMortar(DHMortarVehicleWeaponPawn MortarPwn)
{
    if (MortarPwn != none)
    {
        MortarPawn = MortarPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(MortarPawn);
            Instigator = MortarPawn;
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHMortarVehicleWeaponPawn, so lots of things are not going to work!");
    }
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local coords     MuzzleBoneCoords;
    local vector     X, Y, Z, DebugForward, DebugRight, SpawnLocation;
    local rotator    R, SpawnRotation;
    local float      SpreadYaw;

    MuzzleBoneCoords = GetBoneCoords(MuzzleBoneName);
    GetAxes(Rotation - CurrentAim, X, Y, Z);

    X.Z = 0.0;
    Y.Z = 0.0;

    X = Normal(X);
    Y = Normal(Y);

    R = Rotation - CurrentAim;
    R.Pitch = 0;
    DebugForward = vector(R);
    DebugRight = vect(0.0, 0.0, 1.0) cross DebugForward;

    if (!bDebugNoSpread)
    {
        SpreadYaw = Abs(((Elevation - ElevationMinimum) / (ElevationMaximum - ElevationMinimum)) - 1);
        SpreadYaw = SpreadYawMin + ((SpreadYawMax - SpreadYawMin) * SpreadYaw);
        SpreadYaw = (FRand() - 0.5) * 2.0 * SpreadYaw;
    }

    SpawnLocation = MuzzleBoneCoords.Origin;
    SpawnRotation = rotator(QuatRotatevector(QuatFromAxisAndAngle(Y, -Elevation * DEG2RAD), X));
    SpawnRotation.Yaw += SpreadYaw;

    /* After careful consideration, it was determined that universal pitch adjustments did
    not work, because at lower elevations, the differences in pitch angles becomes
    nearly undetectible, while at high elevations they were overly dramatic.
    In the end, I opted to go with a slight velocity adjustment, as this scales
    fairly nicely at all ranges. -Basnett */

    P = Spawn(ProjClass, Owner,, SpawnLocation, SpawnRotation);

    if (!bDebugNoSpread)
    {
        P.Velocity = vector(P.Rotation) * ((ProjClass.default.MaxSpeed) + ((FRand() - 0.5) * 2.0 * (ProjClass.default.MaxSpeed * 0.05)));
    }
    else
    {
        P.Velocity = vector(P.Rotation) * ProjClass.default.MaxSpeed;
    }

    if (bDebug && DHMortarProjectile(P) != none)
    {
        DHMortarProjectile(P).DebugForward = DebugForward;
        DHMortarProjectile(P).DebugRight = DebugRight;
    }

    PlaySound(FireSound,, 4.0);

    return P;
}

// New functions to handle elevation & depression of mortar's firing angle
simulated function Elevate()
{
    if (Elevation < ElevationMaximum)
    {
        Elevation += ElevationStride;

        if (Instigator != none && DHPlayer(Instigator.Controller) != none)
        {
            DHPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }
    }
}

simulated function Depress()
{
    if (Elevation > ElevationMinimum)
    {
        Elevation -= ElevationStride;

        if (Instigator != none && DHPlayer(Instigator.Controller) != none)
        {
            DHPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }
    }
}

//TODO: charge settings
function IncrementRange() { return; }
function DecrementRange() { return; }

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (bDebugCalibrate)
        {
            for (Elevation = ElevationMinimum; Elevation <= ElevationMaximum; Elevation += ElevationStride)
            {
                SpawnProjectile(PendingProjectileClass, false);
            }
        }
        else
        {
            if (HasPendingAmmo())
            {
                SpawnProjectile(PendingProjectileClass, false);
                MainAmmoCharge[GetPendingRoundIndex()]--;

                //Shake view here, (proper timing and all)
                DHMortarVehicleWeaponPawn(Instigator).ClientShakeView();

                // We fired one off, so we are now eligible for resupply
                DHMortarVehicle(VehicleWeaponPawn(Instigator).VehicleBase).bCanBeResupplied = true;
            }
        }
    }

    function AltFire(Controller C) { }
}

// Modified from ROTankCannon, to allow toggle even if don't have new round type
function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none)
    {
        PendingProjectileClass = SecondaryProjectileClass;
    }
    else
    {
        PendingProjectileClass = PrimaryProjectileClass;
    }
}

simulated function bool HasPendingAmmo()
{
    return MainAmmoCharge[GetPendingRoundIndex()] > 0;
}

// From ROTankCannon
simulated function int GetPendingRoundIndex()
{
    if (PendingProjectileClass == none)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            return 0;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        if (PendingProjectileClass == PrimaryProjectileClass)
        {
            return 0;
        }
        else if (PendingProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
}

simulated function bool IsHighExplosivePending()
{
    return PendingProjectileClass == PrimaryProjectileClass;
}

simulated function bool IsSmokePending()
{
    return PendingProjectileClass == SecondaryProjectileClass;
}

// From ROTankCannon
simulated function UpdatePrecacheStaticMeshes()
{
    if (PrimaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(PrimaryProjectileClass.default.StaticMesh);
    }

    if (SecondaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(SecondaryProjectileClass.default.StaticMesh);
    }

    super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
    // From ROTankCannon:
    bUseTankTurretRotation=true
    bMultipleRoundTypes=true
    AIInfo(0)=(bInstantHit=false,AimError=0.0,RefireRate=5.0)

    Elevation=75.0
    ElevationMaximum=90.0
    ElevationMinimum=45.0
    ElevationStride=0.5
    FireEmitterClass=class'DH_Effects.DH_MortarFireEffect'
    PitchUpLimit=0
    PitchDownLimit=0
    bOwnerNoSee=true
    CollisionHeight=0.0
    CollisionRadius=0.0
}

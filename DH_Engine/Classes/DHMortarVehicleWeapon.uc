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
var     name            GunFiringAnim;
var     name            MuzzleBoneName;
var     float           SpreadYawMin;
var     float           SpreadYawMax;
var     sound           FireSound;
var     int             PlayerResupplyAmounts[2];

// Debugging
var     bool            bDebug;
var     bool            bDebugNoSpread;
var     bool            bDebugCalibrate;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetFiringSettings;
}

// Modified to initialize ammo
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ProjectileClass = PrimaryProjectileClass;

    MainAmmoCharge[0] = 0;
    MainAmmoCharge[1] = 0;
}

// New functions for client to pass Elevation & ProjectileClass to server at specific times, such as firing or leaving the mortar
// Don't need to keep updating these properties between server & owning client, & any exploitation would be completely benign and pointless - Basnett
simulated function SendFiringSettingsToServer()
{
    if (ProjectileClass == default.SecondaryProjectileClass)
    {
        ServerSetFiringSettings(1, Elevation);
    }
    else
    {
        ServerSetFiringSettings(0, Elevation);
    }
}

function ServerSetFiringSettings(byte FireMode, float NewElevation)
{
    if (FireMode == 0)
    {
        ProjectileClass = PrimaryProjectileClass;
    }
    else
    {
        ProjectileClass = SecondaryProjectileClass;
    }

    Elevation = NewElevation;

    if (bDebug && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "ServerSetFiringSettings: Role =" @ GetEnum(enum'ENetRole', Role) @ " Elevation =" @ NewElevation @ " ProjectileClass =" @ ProjectileClass);
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
                SpawnProjectile(ProjectileClass, false);
            }
        }
        else
        {
            if (HasAmmo(GetRoundIndex()))
            {
                SpawnProjectile(ProjectileClass, false);
                --MainAmmoCharge[GetRoundIndex()];

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
    if (ProjectileClass == PrimaryProjectileClass)
    {
        ProjectileClass = SecondaryProjectileClass;
    }
    else
    {
        ProjectileClass = PrimaryProjectileClass;
    }
}

// New function to handle resupply of mortar ammo by another player
function PlayerResupply()
{
    MainAmmoCharge[0] = Clamp(MainAmmoCharge[0] + PlayerResupplyAmounts[0], 0, default.InitialPrimaryAmmo);
    MainAmmoCharge[1] = Clamp(MainAmmoCharge[1] + PlayerResupplyAmounts[1], 0, default.InitialSecondaryAmmo);

    DHMortarVehicle(VehicleWeaponPawn(Instigator).VehicleBase).bCanBeResupplied = MainAmmoCharge[0] < default.InitialPrimaryAmmo || MainAmmoCharge[1] < default.InitialSecondaryAmmo;
}

// New function to return the FireMode index, based on whether HE or smoke rounds are selected (similar to GetPendingRoundIndex in ROTankCannon)
simulated function int GetRoundIndex()
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

// Matt: new function to do set up that requires the 'Gun' reference to the VehicleWeaponPawn actor
// Using it to set a convenient MortarPawn reference & our Owner & Instigator variables (they were previously set in PostNetReceive)
simulated function InitializeWeaponPawn(DHMortarVehicleWeaponPawn MortarPwn)
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

defaultproperties
{
    // From ROTankCannon:
    bUseTankTurretRotation=true
    bMultipleRoundTypes=true
    AIInfo(0)=(bInstantHit=false,AimError=0.0,RefireRate=5.0)

    bForceSkelUpdate=true // necessary for player hit detection, as makes server update the mortar mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    bOwnerNoSee=true
    BeginningIdleAnim="deploy_idle"
    GunFiringAnim="deploy_fire"
    GunnerAttachmentBone="com_player"
    MuzzleBoneName="Muzzle"
    YawBone="Vehicle_attachment01"
    bLimitYaw=true
    PitchUpLimit=0
    PitchDownLimit=0
    Elevation=75.0
    ElevationMaximum=90.0
    ElevationMinimum=45.0
    ElevationStride=0.5
    SpreadYawMin=728.0
    SpreadYawMax=364.0
}

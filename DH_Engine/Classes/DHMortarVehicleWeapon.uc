//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarVehicleWeapon extends DHVehicleWeapon
    abstract;

// Firing, effects & ammo
var     name        GunFiringAnim;            // firing animation for the mortar
var     float       SpreadYawMin;             // minimum & maximum lateral random firing spread
var     float       SpreadYawMax;
var     float       BlurTime;                 // how long screen blur effect should last when firing
var     float       BlurEffectScalar;         // scale for the screen blur when firing
var     int         PlayerResupplyAmounts[2]; // the amount of each round type supplied by another player
var     bool        bLastUpdatedPrimaryAmmo;  // net client records last ammo type passed to server, so can decide if needs to update server

// Mortar elevation
var     float       Elevation;                // current elevation setting, in degrees
var     float       ElevationMaximum;         // maximum & minimum elevation angles
var     float       ElevationMinimum;
var     float       ElevationStride;          // elevation adjustment per key press, in degrees
var     float       LastUpdatedElevation;     // net client records last elevation setting passed to server, so can decide if needs to update server

// Debugging
var     bool        bDebug;
var     bool        bDebugNoSpread;
var     bool        bDebugCalibrate;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetFiringSettings;
}

// New function for net client to pass any changed values of elevation & ammo type to server at specific times when it needs them, i.e. firing or player leaving mortar
// Don't need to keep updating these properties between server & owning client, & any exploitation would be completely benign & pointless - Basnett
// For efficient replication, we pack settings into a single byte, with elevation recorded as increments above minimum & 100 added if it's secondary ammo
simulated function CheckUpdateFiringSettings()
{
    local byte NumElevationIncrements;

    if (Elevation != LastUpdatedElevation || (bLastUpdatedPrimaryAmmo && ProjectileClass != PrimaryProjectileClass))
    {
        LastUpdatedElevation = Elevation;
        bLastUpdatedPrimaryAmmo = ProjectileClass == PrimaryProjectileClass;
        NumElevationIncrements = byte((Elevation - ElevationMinimum) / ElevationStride);

        if (bLastUpdatedPrimaryAmmo)
        {
            ServerSetFiringSettings(NumElevationIncrements);
        }
        else
        {
            ServerSetFiringSettings(NumElevationIncrements + 100);
        }
    }
}

// New replicated client-to-server function for server to receive updated values of elevation & ammo type
// For efficient replication, settings have been packed into a single byte, so we unpack that now
function ServerSetFiringSettings(byte PackedSettings)
{
    local float NumElevationIncrements;

    if (PackedSettings >= 100)
    {
        ProjectileClass = SecondaryProjectileClass;
        PackedSettings -= 100;
    }
    else
    {
        ProjectileClass = PrimaryProjectileClass;
    }

    NumElevationIncrements = float(PackedSettings);
    Elevation = ElevationMinimum + (NumElevationIncrements * ElevationStride);

    if (bDebug)
    {
        Level.Game.Broadcast(self, "ServerSetFiringSettings: Role =" @ GetEnum(enum'ENetRole', Role) @ " Elevation =" @ Elevation @ " ProjectileClass =" @ ProjectileClass);
    }
}

// Modified to handle random pitch/distance spread by adjusting the projectile's initial velocity, instead of adjusting the firing pitch
// After careful consideration, it was determined that universal pitch adjustments did not work for spread,
// because at lower elevations the differences in pitch angles becomes nearly undetectable, while at high elevations they were overly dramatic
// In the end, I opted to go with a slight velocity adjustment, as this scales fairly nicely at all ranges -Basnett
// Also adds a debug option that logs info when projectile explodes
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;

    P = super.SpawnProjectile(ProjClass, bAltFire);

    if (P != none)
    {
        // Adjust projectile's velocity to apply some random distance spread
        if (!bDebugNoSpread)
        {
            P.Velocity *= 1.0 + ((FRand() - 0.5) * 0.1); // scale velocity by +/- 5%
        }

        // Debug option
        if (P.IsA('DHMortarProjectile'))
        {
            DHMortarProjectile(P).VehicleWeapon = self;
        }
    }

    return P;
}

// Modified for unique handling of mortar projectile's random spread
// Spread is only applied to yaw, as pitch/distance spread is represented by a velocity adjustment in SpawnProjectile()
function rotator GetProjectileFireRotation(optional bool bAltFire)
{
    local rotator FireRotation;
    local float   SpreadYaw;

    FireRotation = WeaponFireRotation;

    if (!bDebugNoSpread)
    {
        SpreadYaw = Abs(((Elevation - ElevationMinimum) / (ElevationMaximum - ElevationMinimum)) - 1.0);
        SpreadYaw = SpreadYawMin + ((SpreadYawMax - SpreadYawMin) * SpreadYaw);
        SpreadYaw *= (FRand() - 0.5) * 2.0;

        FireRotation.Yaw += SpreadYaw;
    }

    return FireRotation;
}

// Modified for unique handling of mortar's elevation setting
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local vector  CurrentFireOffset, X, Y, Z;
    local rotator R;

    // Calculate WeaponFireRotation
    R = Rotation - CurrentAim;
    GetAxes(R, X, Y, Z);
    R.Pitch = 0;

    X.Z = 0.0;
    X = Normal(X);
    Y.Z = 0.0;
    Y = Normal(Y);

    WeaponFireRotation = rotator(QuatRotateVector(QuatFromAxisAndAngle(Y, class'UUnits'.static.DegreesToRadians(-Elevation)), X));

    // Calculate WeaponFireLocation
    WeaponFireLocation = GetBoneCoords(WeaponFireAttachmentBone).Origin;

    if (WeaponFireOffset != 0.0) // apply any positional offset
    {
        CurrentFireOffset.X = WeaponFireOffset;
        WeaponFireLocation += CurrentFireOffset >> WeaponFireRotation;
    }
}

// New functions to handle elevation & depression of mortar's firing angle
simulated function Elevate()
{
    if (Elevation < ElevationMaximum)
    {
        Elevation += ElevationStride;
        PlayClickSound();
    }
}

simulated function Depress()
{
    if (Elevation > ElevationMinimum)
    {
        Elevation -= ElevationStride;
        PlayClickSound();
    }
}

// Modified to make sure the mortar base's bCanBeResupplied is set to true after we fire, as mortar must then be eligible for resupply
// Also to add a bDebugCalibrate option that instantaneously fires a mortar shell at each elevation setting
function Fire(Controller C)
{
    if (ProjectileClass != none)
    {
        // Normal mortar fire
        if (!bDebugCalibrate)
        {
            SpawnProjectile(ProjectileClass, false);

            if (DHMortarVehicle(Base) != none)
            {
                DHMortarVehicle(Base).bCanBeResupplied = true;
            }
        }
        // Debugging option
        else
        {
            for (Elevation = ElevationMinimum; Elevation <= ElevationMaximum; Elevation += ElevationStride)
            {
                CalcWeaponFire(false); // need to update fire rotation for each debug projectile
                SpawnProjectile(ProjectileClass, false);
            }
        }
    }
}

// Modified to add blur when firing
simulated function ShakeView(bool bWasAltFire)
{
    if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).AddBlur(BlurTime, BlurEffectScalar);
    }

    super.ShakeView(bWasAltFire);
}

// Emptied out as mortar doesn't use FlashCount to trigger firing effects on all net clients, nor does it use any of the effects functionality
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
}

// Emptied out as mortar doesn't use FlashCount to trigger firing effects on all net clients, so there's no point briefly sending a server into state ServerCeaseFire
// And mortar doesn't use any of the other effects functionality
function CeaseFire(Controller C, bool bWasAltFire)
{
}

// New function to toggle current ammo type, with click sound
// This only happens locally on a net client & any changed ammo type is only passed to the server on firing or the player exiting the mortar
simulated function ToggleRoundType()
{
    if (ProjectileClass == PrimaryProjectileClass)
    {
        ProjectileClass = SecondaryProjectileClass;
    }
    else
    {
        ProjectileClass = PrimaryProjectileClass;
    }

    PlayClickSound();
}

// Emptied out as a mortar re-spawns every time a player deploys it, & we can't have it restored to full ammo every time
// Instead its ammo gets transferred between the mortar & the DHPawn, so when the player acts as the ammo record
function bool GiveInitialAmmo()
{
    return false;
}

// Implemented to handle mortar resupply based on specified resupply quantities, but only for an occupied mortar (ammo is transferred to player when he exits & mortar will be empty)
function bool ResupplyAmmo()
{
    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval && MainAmmoCharge[0] < default.InitialPrimaryAmmo || MainAmmoCharge[1] < default.InitialSecondaryAmmo)
    {
        MainAmmoCharge[0] = Clamp(MainAmmoCharge[0] + PlayerResupplyAmounts[0], 0, default.InitialPrimaryAmmo);
        MainAmmoCharge[1] = Clamp(MainAmmoCharge[1] + PlayerResupplyAmounts[1], 0, default.InitialSecondaryAmmo);

        if (DHMortarVehicle(Base) != none)
        {
            DHMortarVehicle(Base).bCanBeResupplied = MainAmmoCharge[0] < default.InitialPrimaryAmmo || MainAmmoCharge[1] < default.InitialSecondaryAmmo;
        }
        LastResupplyTimestamp = Level.TimeSeconds;
        return true;
    }

    return false;
}

// Functions emptied out as not relevant to a mortar as it doesn't reload or have burning effects
simulated function AttemptReload();
simulated function StartReload(optional bool bResumingPausedReload);
simulated function Timer();
function PassReloadStateToClient();
simulated function ClientSetReloadState(byte NewState);
simulated function PauseReload();
simulated function bool HasAmmoToReload(byte AmmoIndex) { return false; }
simulated function StartHatchFire();

defaultproperties
{
    // Mesh & animation
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update mortar mesh skeleton (wouldn't otherwise as server doesn't draw mesh)
    bOwnerNoSee=true
    BeginningIdleAnim="deploy_idle"
    GunnerAttachmentBone="com_player"
    WeaponFireAttachmentBone="Muzzle"
    GunFiringAnim="deploy_fire"

    // Aiming
    bUseTankTurretRotation=true
    YawBone="Vehicle_attachment01"
    bLimitYaw=true
    SpreadYawMin=728.0
    SpreadYawMax=364.0
    Elevation=75.0
    ElevationMaximum=90.0
    ElevationMinimum=45.0
    ElevationStride=0.5

    // Ammo & firing
    bMultipleRoundTypes=true
    bMultiStageReload=false
    bPrimaryIgnoreFireCountdown=true // necessary to prevent net client from sometimes sending instruction to server to cease fire before server has had time to fire
    FireSoundVolume=512.0
    BlurTime=0.5
    BlurEffectScalar=1.35
    AIInfo(0)=(AimError=0.0,WarnTargetPct=0.0)
    ResupplyInterval=20.0
}

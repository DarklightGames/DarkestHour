//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector     SpawnLocation, X, Y, Z;
    local rotator    SpawnRotation, R;
    local float      SpreadYaw;

    R = Rotation - CurrentAim;
    GetAxes(R, X, Y, Z);

    R.Pitch = 0;

    X.Z = 0.0;
    X = Normal(X);

    Y.Z = 0.0;
    Y = Normal(Y);

    SpawnLocation = GetBoneCoords(WeaponFireAttachmentBone).Origin;
    SpawnRotation = rotator(QuatRotatevector(QuatFromAxisAndAngle(Y, class'UUnits'.static.DegreesToRadians(-Elevation)), X));

    if (!bDebugNoSpread)
    {
        SpreadYaw = Abs(((Elevation - ElevationMinimum) / (ElevationMaximum - ElevationMinimum)) - 1.0);
        SpreadYaw = SpreadYawMin + ((SpreadYawMax - SpreadYawMin) * SpreadYaw);
        SpreadYaw *= (FRand() - 0.5) * 2.0;

        SpawnRotation.Yaw += SpreadYaw;
    }

    P = Spawn(ProjClass, Owner,, SpawnLocation, SpawnRotation);

    /* After careful consideration, it was determined that universal pitch adjustments did not work,
    because at lower elevations the differences in pitch angles becomes nearly undetectable, while at high elevations they were overly dramatic.
    In the end, I opted to go with a slight velocity adjustment, as this scales fairly nicely at all ranges. -Basnett */

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
        DHMortarProjectile(P).DebugForward = vector(R);
        DHMortarProjectile(P).DebugRight = vect(0.0, 0.0, 1.0) cross vector(R);
    }

    PlaySound(GetFireSound(),, 4.0);

    return P;
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
            if (HasAmmo(GetFireMode()))
            {
                SpawnProjectile(ProjectileClass, false);
                --MainAmmoCharge[GetFireMode()];

                // We fired one off, so we are now eligible for resupply
                if (DHMortarVehicle(Base) != none)
                {
                    DHMortarVehicle(Base).bCanBeResupplied = true;
                }
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
}

// New function to handle resupply of mortar ammo by another player
function PlayerResupply()
{
    MainAmmoCharge[0] = Clamp(MainAmmoCharge[0] + PlayerResupplyAmounts[0], 0, default.InitialPrimaryAmmo);
    MainAmmoCharge[1] = Clamp(MainAmmoCharge[1] + PlayerResupplyAmounts[1], 0, default.InitialSecondaryAmmo);

    if (DHMortarVehicle(Base) != none)
    {
        DHMortarVehicle(Base).bCanBeResupplied = MainAmmoCharge[0] < default.InitialPrimaryAmmo || MainAmmoCharge[1] < default.InitialSecondaryAmmo;
    }
}

defaultproperties
{
    // Mesh & animation
    bForceSkelUpdate=true // Matt: necessary for new player hit detection system, as makes server update mortar mesh skeleton (wouldn't otherwise as server doesn't draw mesh)
    bOwnerNoSee=true
    BeginningIdleAnim="deploy_idle"
    GunnerAttachmentBone="com_player"
    WeaponFireAttachmentBone="Muzzle"
    GunFiringAnim="deploy_fire"

    // Movement
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
    BlurTime=0.5
    BlurEffectScalar=1.35
    AIInfo(0)=(AimError=0.0,WarnTargetPct=0.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicleWeapon extends DHVehicleWeapon
    abstract;

// Firing, effects & ammo
var     name        GunFiringAnim;    // firing animation for the mortar
var     float       SpreadYawMin;     // minimum & maximum lateral random firing spread
var     float       SpreadYawMax;
var     float       BlurTime;         // how long screen blur effect should last when firing
var     float       BlurEffectScalar; // scale for the screen blur when firing
var     int         PlayerResupplyAmounts[2]; // the amount of each round type supplied by another player

// Mortar elevation
var     float       Elevation;        // current elevation setting, in degrees
var     float       ElevationMaximum; // maximum & minimum elevation angles
var     float       ElevationMinimum;
var     float       ElevationStride;  // elevation adjustment per key press, in degrees

// Debugging
var     bool        bDebug;
var     bool        bDebugNoSpread;
var     bool        bDebugCalibrate;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetFiringSettings;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientShakeView;
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

        if (Instigator != none && Instigator.IsHumanControlled())
        {
            PlayerController(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }
    }
}

simulated function Depress()
{
    if (Elevation > ElevationMinimum)
    {
        Elevation -= ElevationStride;

        if (Instigator != none && Instigator.IsHumanControlled())
        {
            PlayerController(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }
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
                ClientShakeView(); // shake view here, (proper timing & all)

                // We fired one off, so we are now eligible for resupply
                if (DHMortarVehicle(Base) != none)
                {
                    DHMortarVehicle(Base).bCanBeResupplied = true;
                }
            }
        }
    }
}

// New function to shake player's view when firing
simulated function ClientShakeView()
{
    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).AddBlur(BlurTime, BlurEffectScalar);
        Instigator.Controller.ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}

// New function, similar to a cannon, but allowing toggle even if don't have new round type
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

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarVehicleWeapon extends ROTankCannon;

const RAD2DEG = 57.29577951;
const DEG2RAD = 0.01745329;

//Bones
var name MuzzleBoneName;

//Trajectory
var float NewElevation;
var float Elevation;
var float ElevationMaximum;
var float ElevationMinimum;
var float ElevationStride;

var class<Emitter> FireEmitterClass;

var sound FireSound;

var float SpreadYawMin;
var float SpreadYawMax;

var bool bDebug;
var bool bDebugNoSpread;
var bool bDebugCalibrate;

replication
{
    reliable if (Role < ROLE_Authority)
        ClientReplicateElevation;
}

/*
Added in 5.1 to replace constantly sending Elevate() and Depress()
calls to the server and sending the Elevation variable to the owning
client.  Client calls this function to update the server's elevation
setting at specific times such as firing or leaving the mortar.

Exploitation would be completetly beneign and pointless.
- Basnett
*/
simulated function ClientReplicateElevation(float Elevation)
{
    if (bDebug && Role == ROLE_Authority)
        Level.Game.Broadcast(self, Role @ "ClientReplicateElevation" @ Elevation);

    self.Elevation = Elevation;
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (Role == ROLE_Authority && Elevation != NewElevation)
    {
        Level.Game.Broadcast(self, "PostNetReceive" @ Elevation @ NewElevation);

        Elevation = NewElevation;
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PendingProjectileClass = PrimaryProjectileClass;

    MainAmmoCharge[0] = 0;
    MainAmmoCharge[1] = 0;
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector X, Y, Z, SpawnLocation;
    local rotator SpawnRotation;
    local coords MuzzleBoneCoords;
    local float SpreadYaw;
    local rotator R;
    local vector DebugForward, DebugRight;

    MuzzleBoneCoords = GetBoneCoords(MuzzleBoneName);
    GetAxes(Rotation - CurrentAim, X, Y, Z);

    X.Z = 0;
    Y.Z = 0;

    X = Normal(X);
    Y = Normal(Y);

    R = Rotation - CurrentAim;
    R.Pitch = 0;
    DebugForward = vector(R);
    DebugRight = vect(0, 0, 1) cross DebugForward;

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

    P = Spawn(ProjClass, Owner, , SpawnLocation, SpawnRotation);

    if (!bDebugNoSpread)
        P.Velocity = vector(P.Rotation) * ((ProjClass.default.MaxSpeed) + ((FRand() - 0.5) * 2.0 * (ProjClass.default.MaxSpeed * 0.05)));
    else
        P.Velocity = vector(P.Rotation) * ProjClass.default.MaxSpeed;

    if (DH_MortarProjectile(P) != none && Pawn(Owner) != none)
    {
        DH_MortarProjectile(P).DamageInstigator = PlayerController(Pawn(Owner).Controller);

        if (bDebug)
        {
            DH_MortarProjectile(P).DebugForward = DebugForward;
            DH_MortarProjectile(P).DebugRight = DebugRight;
        }
    }

    PlaySound(FireSound, , 4.0);

    return P;
}

simulated function Elevate()
{
    if (Elevation < ElevationMaximum)
    {
        Elevation += ElevationStride;

        if (Instigator != none && Instigator.Controller != none && DHPlayer(Instigator.Controller) != none)
            DHPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);
    }
}

simulated function Depress()
{
    if (Elevation > ElevationMinimum)
    {
        Elevation -= ElevationStride;

        if (Instigator != none && Instigator.Controller != none && DHPlayer(Instigator.Controller) != none)
            DHPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);
    }
}

//TODO: Charge settings.
function IncrementRange() { return; }
function DecrementRange() { return; }

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (bDebugCalibrate)
        {
            for(Elevation = ElevationMinimum; Elevation <= ElevationMaximum; Elevation += ElevationStride)
                SpawnProjectile(PendingProjectileClass, false);
        }
        else
        {
            if (HasPendingAmmo())
            {
                SpawnProjectile(PendingProjectileClass, false);
                MainAmmoCharge[GetPendingRoundIndex()]--;

                //Shake view here, (proper timing and all)
                DH_MortarVehicleWeaponPawn(Instigator).ClientShakeView();

                // We fired one off, so we are now eligible for resupply.
                DH_MortarVehicle(VehicleWeaponPawn(Instigator).VehicleBase).bCanBeResupplied = true;
            }
        }
    }

    function AltFire(Controller C) { }
}

function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none)
        PendingProjectileClass = SecondaryProjectileClass;
    else
        PendingProjectileClass = PrimaryProjectileClass;
}

simulated function bool HasPendingAmmo()
{
    return MainAmmoCharge[GetPendingRoundIndex()] > 0;
}

simulated function bool IsHighExplosivePending()
{
    return PendingProjectileClass == PrimaryProjectileClass;
}

simulated function bool IsSmokePending()
{
    return PendingProjectileClass == SecondaryProjectileClass;
}

defaultproperties
{
     Elevation=75.000000
     ElevationMaximum=90.000000
     ElevationMinimum=45.000000
     ElevationStride=0.500000
     FireEmitterClass=class'DH_Effects.DH_MortarFireEffect'
     PitchUpLimit=0
     PitchDownLimit=0
     bOwnerNoSee=true
     CollisionHeight=0.0
     CollisionRadius=0.0
}

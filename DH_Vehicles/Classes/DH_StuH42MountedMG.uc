//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42MountedMG extends ROVehicleWeapon;

var()   class<Projectile> TracerProjectileClass; // Matt: replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so the old name was misleading
var()   int               TracerFrequency;       // how often a tracer is loaded in (as in: 1 in the value of TracerFrequency)

var()   sound ReloadSound; // sound of this MG reloading
var     bool  bReloading;  // This MG is currently reloading
var     int   NumMags;     // Number of mags carried for this MG;

// Stuff for fire effects - Ch!cKeN
var()   name                                    FireAttachBone;
var()   vector                                  FireEffectOffset;
var     class<VehicleDamagedEffect>             FireEffectClass;
var     VehicleDamagedEffect                    HullMGFireEffect;
var     bool                                    bOnFire;   // Set by Treadcraft base to notify when to start fire effects
var     float                                   BurnTime;

var     class<DamageType>   VehicleBurningDamType;
var     float               PlayerFireDamagePerSec;

replication
{
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        bReloading, NumMags;

    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire;
}

static function StaticPrecache(LevelInfo L)
{
   // L.AddPrecacheMaterial(Material'VMparticleTextures.TankFiringP.CloudParticleOrangeBMPtex');
}

simulated function UpdatePrecacheMaterials()
{
   // Level.AddPrecacheMaterial(Material'VMparticleTextures.TankFiringP.CloudParticleOrangeBMPtex');

    super.UpdatePrecacheMaterials();
}

simulated function Tick(float DeltaTime)
{

    super.Tick(DeltaTime);

    if (bOnFire && HullMGFireEffect == none)
    {
        // Lets randomise the fire start times to desync them with the driver and engine ones
        if (Level.TimeSeconds - BurnTime > 0.2)
        {
            if (FRand() < 0.1)
            {
                HullMGFireEffect = Spawn(FireEffectClass);
                AttachToBone(HullMGFireEffect, FireAttachBone);
                HullMGFireEffect.SetRelativeLocation(FireEffectOffset);
                HullMGFireEffect.UpdateDamagedEffect(true, 0, false, false);
            }
            BurnTime = Level.TimeSeconds;
        }
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (HullMGFireEffect != none)
        HullMGFireEffect.Destroy();
}

// Limit the left and right movement of the turret based on the rotation of the vehicle
simulated function int LimitYaw(int yaw)
{
    local int NewYaw;
    local int VehYaw;

    if (!bLimitYaw)
    {
        return yaw;
    }

    VehYaw = VehicleWeaponPawn(Owner).VehicleBase.Rotation.Yaw;

    NewYaw = yaw;

    if (yaw > VehYaw + MaxPositiveYaw)
    {
        NewYaw = VehYaw + MaxPositiveYaw;
    }
    else if (yaw < VehYaw + MaxNegativeYaw)
    {
        NewYaw = VehYaw + MaxNegativeYaw;
    }

    return NewYaw;
}

function byte BestMode()
{
    return 0;
}

// Returns true if this weapon is ready to fire
simulated function bool ReadyToFire(bool bAltFire)
{
    //Log("bReloading =" @ bReloading);

    if (bReloading)
        return false;

    return super.ReadyToFire(bAltFire);
}

function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (!bReloading && !HasAmmo(0))
        HandleReload();
}

function HandleReload()
{
    if (NumMags > 0 && !bReloading)
    {
        bReloading = true;
        NumMags--;
        NetUpdateTime = Level.TimeSeconds - 1;
        SetTimer(GetSoundDuration(ReloadSound), false);
        PlaySound(ReloadSound, SLOT_None, 1.5,, 25,, true);
    }
}

simulated function Timer()
{
   if (bReloading)
   {
        if (Role == ROLE_Authority)
        {
            bReloading = false;
            MainAmmoCharge[0] = InitialPrimaryAmmo;
            NetUpdateTime = Level.TimeSeconds - 1;
        }
   }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
    if (Role != ROLE_Authority || bForceCenterAim)
        return false;

    if (FireCountdown <= 0)
    {
        CalcWeaponFire(bAltFire);
        if (bCorrectAim)
            WeaponFireRotation = AdjustAim(bAltFire);

        if (bAltFire)
        {
            if (AltFireSpread > 0)
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*AltFireSpread);
        }
        else if (Spread > 0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*Spread);
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);
        if (bAltFire)
        {
            if (!ConsumeAmmo(2))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                return false;
            }
            FireCountdown = AltFireInterval;
            AltFire(C);
        }
        else
        {
            if (bMultipleRoundTypes)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    if (!ConsumeAmmo(0))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                }
            }
            else if (!ConsumeAmmo(0))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();
                return false;
            }

            FireCountdown = FireInterval;
            Fire(C);
        }
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

// Matt: modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
state ProjectileFireMode
{
	function Fire(Controller C)
	{
        // Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly (result = 0) then it's time to fire a tracer
        if (bUsesTracers && ((InitialPrimaryAmmo - MainAmmoCharge[0] - 1) % TracerFrequency == 0.0))
        {
            SpawnProjectile(TracerProjectileClass, false);
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

// Matt: modified to remove the Super in ROVehicleWeapon to remove calling UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
	super(VehicleWeapon).FlashMuzzleFlash(bWasAltFire);
}

// Fill the ammo up to the initial ammount
function bool GiveInitialAmmo()
{
    local bool bDidResupply;

    if (NumMags != default.NumMags)
    {
        bDidResupply = true;
    }

    MainAmmoCharge[0] = InitialPrimaryAmmo;
    MainAmmoCharge[1] = InitialSecondaryAmmo;
    AltAmmoCharge = InitialAltAmmo;
    NumMags = default.NumMags;

    return bDidResupply;
}

simulated function int getNumMags()
{
    return NumMags;
}

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=8
    FireAttachBone="gunner_int"
    FireEffectOffset=(Z=5.0)
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    VehicleBurningDamType=class'DH_VehicleBurningDamType'
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    bUsesTracers=true
    VehHitpoints(0)=(PointRadius=15.0,PointScale=1.0,PointBone="loader_player",PointOffset=(Z=-16.0))
    bIsMountedTankMG=true
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="loader_attachment"
    WeaponFireOffset=3.0
    RotationsPerSecond=0.05
    bInstantRotation=true
    bDoOffsetTrace=true
    bAmbientFireSound=true
    bIsRepeatingFF=true
    Spread=0.002
    FireInterval=0.07058
    AltFireInterval=0.07058
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    FireForce="minifireb"
    DamageType=class'ROGame.ROVehMountedMGDamType'
    DamageMin=25
    DamageMax=25
    TraceRange=15000.0
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(X=25.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=0.5,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=63500
    MaxPositiveYaw=5500
    MaxNegativeYaw=-5500
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=75
    CullDistance=8000.0
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}

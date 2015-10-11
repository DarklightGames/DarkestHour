//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountCannon extends DHVehicleCannon;

var     byte                    BarrelBoneIndex;        // bone index for each gun
var     name                    BarrelBones[4];         // bone names for 4 barrels
var     WeaponAmbientEmitter    BarrelEffectEmitter[4]; // separate flash emitter for each barrel

// Modified to switch fire button functionality to alt fire
event bool AttemptFire(Controller C, bool bAltFire)
{
    return super.AttemptFire(C, true);
}

// Modified to handle multiple barrel fire
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector     StartLocation, BarrelLocation[4];
    local rotator    FireRot, BarrelRotation[4];
    local int        i;

    GetBarrelLocationAndRotation(0, BarrelLocation[0], BarrelRotation[0]);
    GetBarrelLocationAndRotation(1, BarrelLocation[1], BarrelRotation[1]);
    GetBarrelLocationAndRotation(2, BarrelLocation[2], BarrelRotation[2]);
    GetBarrelLocationAndRotation(3, BarrelLocation[3], BarrelRotation[3]);

    for (i = 0; i < 4; ++i)
    {
        FireRot = BarrelRotation[i];

        if (Instigator != none && Instigator.IsHumanControlled())
        {
            FireRot.Pitch += AddedPitch;
        }

        StartLocation = BarrelLocation[i];

        P = Spawn(ProjClass, none,, StartLocation, FireRot);

        if (P != none)
        {
            FlashMuzzleFlash(bAltFire);

            AmbientSound = AltFireSoundClass;
            SoundVolume = AltFireSoundVolume;
            SoundRadius = AltFireSoundRadius;
            AmbientSoundScaling = AltFireSoundScaling;
        }
    }

    return P;
}

// Modified to enable the emitter for multiple barrels (also stripping out all redundancy for this weapon)
simulated event OwnerEffects()
{
    if (Role < ROLE_Authority)
    {
        // Stop the firing effects it we shouldn't be able to fire
        // (incorporating extra from DHVehicleCannon to stop 'phantom' coaxial MG firing effects if player has moved to ineligible firing position while holding down fire button)
        if (!ReadyToFire(true) || (CannonPawn != none && !CannonPawn.CanFire()))
        {
            VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);

            return;
        }

        FireCountdown = AltFireInterval;
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        FlashMuzzleFlash(bIsAltFire);

        SoundVolume = AltFireSoundVolume;
        SoundRadius = AltFireSoundRadius;
        AmbientSoundScaling = AltFireSoundScaling;
    }

    SetBarrelEffectEmitterStatus(true);
}

// Modified to disable the emitter for multiple barrels
function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    SetBarrelEffectEmitterStatus(false);
}

// Modified to disable the emitter for multiple barrels (also stripping out all redundancy for this weapon)
simulated function ClientStopFire(Controller C, bool bWasAltFire)
{
    StopForceFeedback(AltFireForce);

    if (Role < ROLE_Authority)
    {
        SetBarrelEffectEmitterStatus(false);
    }
}

// New function to get the location & rotation of barrel that is firing
simulated function GetBarrelLocationAndRotation(int Index, out vector BarrelLocation, out rotator BarrelRotation)
{
    local coords BarrelBoneCoords;
    local vector CurrentFireOffset;

    if (Index < 0 || Index >= arraycount(BarrelBones))
    {
        return;
    }

    BarrelBoneCoords = GetBoneCoords(BarrelBones[Index]);
    CurrentFireOffset = WeaponFireOffset * vect(1.0, 0.0, 0.0);

    BarrelRotation = rotator(vector(CurrentAim) >> Rotation);
    BarrelLocation = BarrelBoneCoords.Origin + (CurrentFireOffset >> BarrelRotation);
}

// Modified to get WeaponFireLocation for the barrel that is currently firing
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Get bone co-ordinates on which to to base fire location
    WeaponBoneCoords = GetBoneCoords(BarrelBones[BarrelBoneIndex++]);
    BarrelBoneIndex = Clamp(BarrelBoneIndex, 0, 3);

    // Calculate fire position offset
    CurrentFireOffset = AltFireOffset + (AltFireSpawnOffsetX * vect(1.0, 0.0, 0.0));

    // Calculate rotation of the cannon's aim
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);

    // Calculate exact fire location
    WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);
}

// Modified to handle multiple barrels
simulated function InitEffects()
{
    local int i;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    for (i = 0; i < 4; ++i)
    {
        if (AmbientEffectEmitterClass != none && BarrelEffectEmitter[i] == none)
        {
            BarrelEffectEmitter[i] = Spawn(AmbientEffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

            if (BarrelEffectEmitter[i] != none)
            {
                AttachToBone(BarrelEffectEmitter[i], BarrelBones[i]);
                BarrelEffectEmitter[i].SetRelativeLocation(AltFireOffset);
            }
        }
    }
}

// New function to set the emitter status for multiple barrels
simulated function SetBarrelEffectEmitterStatus(bool bActive)
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < 4; ++i)
        {
            if (BarrelEffectEmitter[i] != none)
            {
                BarrelEffectEmitter[i].SetEmitterStatus(bActive);
            }
        }
    }
}

defaultproperties
{
    CannonAttachmentOffset=(X=0.0,Y=0.0,Z=6.7)
    AltFireProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet'
    ProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet' // just to stop log spam
    InitialAltAmmo=200
    NumAltMags=10 // TEMP - unknown, needs setting
    AltFireInterval=0.133333 // 450 RPM
    bUsesTracers=true
    AltFireTracerFrequency=5
    bAltFireTracersOnly=true
    AltTracerProjectileClass=class'DH_Vehicles.DH_50CalVehicleTracerBullet'
    BarrelBones(0)="Barrel_TL"
    BarrelBones(1)="Barrel_TR"
    BarrelBones(2)="Barrel_BL"
    BarrelBones(3)="Barrel_BR"
    HudAltAmmoIcon=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    AltFireOffset=(X=-2.0,Y=0.0,Z=0.0)
    GunnerAttachmentBone="com_attachment"
    BeginningIdleAnim="lookover_idle_down"
    RotationsPerSecond=0.1667 // 60 degrees per second
    bLimitYaw=true
    MaxPositiveYaw=9000 // until turret hits wheels
    MaxNegativeYaw=-9000
    YawStartConstraint=-10000.0
    YawEndConstraint=10000.0
    YawBone="Turret"
    PitchBone="Gun"
    CustomPitchUpLimit=16384   // 90 degrees elevation
    CustomPitchDownLimit=63716 // 10 degrees depression
    PitchUpLimit=20000
    PitchDownLimit=45000
    bAmbientAltFireSound=true
    AltFireSoundScaling=5.0
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    bIsRepeatingFF=true
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    Mesh=SkeletalMesh'DH_M45_anm.m45_turret'
    Skins(0)=texture'DH_Artillery_tex.m45.m45_gun'
    Skins(1)=texture'DH_Artillery_tex.m45.m45_sight'
}

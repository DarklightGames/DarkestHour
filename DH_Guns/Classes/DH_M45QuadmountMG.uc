//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountMG extends DHVehicleMG;

var     byte                    BarrelBoneIndex;        // bone index for each gun
var     name                    BarrelBones[4];         // bone names for 4 barrels
var     WeaponAmbientEmitter    BarrelEffectEmitter[4]; // separate flash emitter for each barrel

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
        FireRot = rotator(vector(BarrelRotation[i]) + VRand() * FRand() * Spread);
        StartLocation = BarrelLocation[i];

        P = Spawn(ProjClass, none,, StartLocation, FireRot);

        if (P != none)
        {
            FlashMuzzleFlash(bAltFire);
            AmbientSound = FireSoundClass;
        }
    }

    return P;
}

// Modified to enable the emitter for multiple barrels (also stripping out all redundancy for this weapon)
simulated function OwnerEffects()
{
    if (Role < ROLE_Authority)
    {
        // Stop the firing effects it we shouldn't be able to fire
        // (incorporating extra from DHVehicleMG to stop 'phantom' firing effects if player has moved to ineligible firing position while holding down fire button)
        if (!ReadyToFire(bIsAltFire) || (MGPawn != none && !MGPawn.CanFire()))
        {
            VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);

            return;
        }

        FireCountdown = FireInterval;
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        FlashMuzzleFlash(bIsAltFire);
    }

    ShakeView(bIsAltFire);
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
    StopForceFeedback(FireForce);

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
    CurrentFireOffset = WeaponFireOffset * vect(1.0, 0.0, 0.0);

    // Calculate rotation of the weapon's aim
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
                BarrelEffectEmitter[i].SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));

                // Hacky, but set the shell case emitter properties to suit this weapon, avoiding the need for separate classes
                if (i == 0 || i == 2) // left side guns
                {
                    BarrelEffectEmitter[i].Emitters[0].StartLocationOffset = vect(-77.0, 4.0, 2.0);
                    BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Min = 0.0;
                    BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Max = 10.0;
                }
                else // right side guns
                {
                    BarrelEffectEmitter[i].Emitters[0].StartLocationOffset = vect(-77.0, -4.0, 2.0);
                    BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Min = -10.0;
                    BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Max = 0.0;
                }
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
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    bUseTankTurretRotation=true
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750
    ProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet'
    InitialPrimaryAmmo=200
    NumMags=10 // TODO: unknown, needs setting
    FireInterval=0.133333 // 450 RPM
    TracerFrequency=5
    TracerProjectileClass=class'DH_Vehicles.DH_50CalVehicleTracerBullet'
    BarrelBones(0)="Barrel_TL"
    BarrelBones(1)="Barrel_TR"
    BarrelBones(2)="Barrel_BL"
    BarrelBones(3)="Barrel_BR"
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo' // TODO: make ammo icon for 50 cal 'tombstone' ammo chest
    bInstantFire=false
    WeaponFireOffset=2.0
    GunnerAttachmentBone="Gun"
    BeginningIdleAnim="lookover_idle_down"
    bInstantRotation=true //false
    RotationsPerSecond=0.1667 // 60 degrees per second
    bLimitYaw=true
    MaxPositiveYaw=9000 // until turret hits wheels
    MaxNegativeYaw=-9000
    YawStartConstraint=-10000.0
    YawEndConstraint=10000.0
    YawBone="Turret"
    PitchBone="Gun"
    CustomPitchUpLimit=10000 // TEST - reduced to stop feet poking through - fine tune based on gunner's final anim & positioning
    CustomPitchDownLimit=63716 // 10 degrees depression
    PitchUpLimit=20000
    PitchDownLimit=45000
    FireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    AmbientSoundScaling=5.0
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.05,Y=0.0,Z=0.05)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(1)=(bLeadTarget=true,bFireOnRelease=true,AimError=800.0,RefireRate=0.133333)
    FireEffectClass=none // no hatch fire effect
    CullDistance=0.0 // override unwanted 8k from ROMountedTankMG
    bDoOffsetTrace=false
    MGAttachmentOffset=(X=0.0,Y=0.0,Z=6.7) // TODO: correct attachment bone positioning in trailer skeletal mesh (this fixes for now)
    Mesh=SkeletalMesh'DH_M45_anm.m45_turret'
    Skins(0)=texture'DH_Artillery_tex.m45.m45_gun'
    Skins(1)=texture'DH_Artillery_tex.m45.m45_sight'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}

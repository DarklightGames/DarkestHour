//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HetzerMountedMG extends DH_ROMountedTankMG;

#exec OBJ LOAD FILE=..\Sounds\inf_weapons_foley.uax

var()   sound   MGReloadSoundOne;   // 4 part reload functionality based on a tank cannon (and all new variables below)
var()   sound   MGReloadSoundTwo;
var()   sound   MGReloadSoundThree;
var()   sound   MGReloadSoundFour;

var     bool    bClientCanFireMG;   // flag that is set on the server and replicated to the client that determines if the MG can fire

var     enum    EMGReloadState
{
    MG_Waiting,
    MG_Empty,
    MG_ReloadedPart1,
    MG_ReloadedPart2,
    MG_ReloadedPart3,
    MG_ReloadedPart4,
    MG_ReadyToFire,
}   MGReloadState;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        bClientCanFireMG;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerManualReload;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientSetReloadState;
}

// Modified to add 'dry fire' jolt & click if MG isn't loaded
simulated function bool ReadyToFire(bool bAltFire)
{
    if ((MGReloadState != MG_ReadyToFire || !bClientCanFireMG) && !bAltFire)
    {
        ShakeView(false);
        PlaySound(NoAmmoSound, SLOT_None, 1.5,, 25.0,, true);

        return false;
    }

    return super(VehicleWeapon).ReadyToFire(bAltFire);
}

// Doesn't actually handle MG reload, it just sets MG to empty & waiting for reload - but redefining this avoids need to redefine lengthy AttemptFire()
function HandleReload()
{
    bClientCanFireMG = false;
    MGReloadState = MG_Empty;
    SetTimer(0.01, false);
}

// Called by ROManualReload from the MG Pawn - sets MGReloadState to MG_Empty, which starts a 4 part reload (tank cannon functionality)
function ServerManualReload()
{
    if (NumMags > 0 && (MGReloadState == MG_Waiting || MGReloadState == MG_ReadyToFire))
    {
        NumMags--;
        MGReloadState = MG_Empty;
        ClientSetReloadState(MGReloadState);
        SetTimer(0.01, false);
    }
}

// Part of 4 part reload functionality, based on tank cannon
simulated function ClientSetReloadState(EMGReloadState NewState)
{
    MGReloadState = NewState;
    SetTimer(0.01, false);
}

// Added 4 part reload similar to a tank cannon
simulated function Timer()
{
    local DH_HetzerMountedMGPawn MGP;

    MGP = DH_HetzerMountedMGPawn(Owner);

    // Pause reload if there is the MG has no Controller or if buttoned up or in the process of buttoning or unbuttoning
    if (MGP == none || MGP.Controller == none || MGP.DriverPositionIndex < MGP.UnbuttonedPositionIndex || MGP.IsInState('ViewTransition'))
    {
        SetTimer(0.05, true);
    }
    else if (MGReloadState == MG_Empty)
    {
        PlayOwnedSound(MGReloadSoundOne, SLOT_Misc, 2.0,, 150,, false); // doubled the default volume
        MGReloadState = MG_ReloadedPart1;
        SetTimer(GetSoundDuration(MGReloadSoundOne), false);
    }
    else if (MGReloadState == MG_ReloadedPart1)
    {
        PlayOwnedSound(MGReloadSoundTwo, SLOT_Misc, 2.0,, 150,, false);
        MGReloadState = MG_ReloadedPart2;
        SetTimer(GetSoundDuration(MGReloadSoundTwo), false);
    }
    else if (MGReloadState == MG_ReloadedPart2)
    {
        PlayOwnedSound(MGReloadSoundThree, SLOT_Misc, 2.0,, 150,, false);
        MGReloadState = MG_ReloadedPart3;
        SetTimer(GetSoundDuration(MGReloadSoundThree), false);
    }
    else if (MGReloadState == MG_ReloadedPart3)
    {
        PlayOwnedSound(MGReloadSoundFour, SLOT_Misc, 2.0,, 150,, false);
        MGReloadState = MG_ReloadedPart4;
        SetTimer(GetSoundDuration(MGReloadSoundFour), false);
    }
    else if (MGReloadState == MG_ReloadedPart4)
    {
        if (Role == ROLE_Authority)
        {
            bClientCanFireMG = true;
            MainAmmoCharge[0] = InitialPrimaryAmmo;
        }

        MGReloadState = MG_ReadyToFire;
        SetTimer(0.0, false);
    }
}

defaultproperties
{
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    MGReloadSoundOne=sound'Inf_Weapons_Foley.mg34.mg34_reload01_000'
    MGReloadSoundTwo=sound'Inf_Weapons_Foley.mg34.mg34_reload02_039'
    MGReloadSoundThree=sound'Inf_Weapons_Foley.mg34.mg34_reload03_104'
    MGReloadSoundFour=sound'Inf_Weapons_Foley.mg34.mg34_reload04_170'
    bClientCanFireMG=true
    MGReloadState=MG_ReadyToFire
    NumMags=12
    FireAttachBone="gunner_int"
    FireEffectOffset=(Y=6.0)
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    VehHitpoints(0)=(PointRadius=8.0,PointScale=1.0,PointBone="loader_attachment",PointOffset=(X=12.5,Y=6.0,Z=43.0))
    VehHitpoints(1)=(PointRadius=17.0,PointScale=1.0,PointBone="loader_attachment",PointOffset=(X=5.0,Y=6.0,Z=18.5))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="loader_attachment"
    WeaponFireOffset=3.0
    RotationsPerSecond=0.5
    bInstantFire=false
    Spread=0.002
    FireInterval=0.07058
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=2100
    CustomPitchDownLimit=63100
    BeginningIdleAnim="loader_idle_close"
    InitialPrimaryAmmo=50
    Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_mg'
    Skins(0)=texture'DH_Hetzer_tex_V1.hetzer_body'
    Skins(1)=texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}

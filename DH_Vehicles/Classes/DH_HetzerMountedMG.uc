//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerMountedMG extends DH_ROMountedTankMG;

#exec OBJ LOAD FILE=..\Sounds\inf_weapons_foley.uax

var()   sound   NoAmmoSound; // Matt: 'dry fire' sound when trying to fire MG empty

var()   sound   MGReloadSoundOne; // Matt: 4 part reload functionality based on a tank cannon (and all new variables below)
var()   sound   MGReloadSoundTwo;
var()   sound   MGReloadSoundThree;
var()   sound   MGReloadSoundFour;

var     bool    bClientCanFireMG; // Matt: flag that is set on the server and replicated to the client that determines if the MG can fire

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
    // Variables the server should send to the client
    reliable if( bNetDirty && Role==ROLE_Authority )
        bClientCanFireMG;

    // Functions the server calls on the client side.
    reliable if( Role == ROLE_Authority )
        ClientSetReloadState;

    // Functions the client calls on the server side:
    reliable if ( Role < ROLE_Authority )
        ServerManualReload;
}

// Matt: modified to add 'dry fire' effects if MG isn't loaded
simulated function bool ReadyToFire(bool bAltFire)
{
    if( (MGReloadState != MG_ReadyToFire || !bClientCanFireMG) && !bAltFire )
    {
        ShakeView(false); // Matt: added to jolt when trying to fire empty
        PlaySound(NoAmmoSound, SLOT_None,1.5,, 25, , true); // Matt: added to play click sound when trying to fire empty
        return false;
    }

    return Super(VehicleWeapon).ReadyToFire(bAltFire);
}

// Matt: reverted back to CeaseFire from VehicleWeapon as parent DH_HiddenTankHullMG introduces auto-reload of MG when runs out of ammo
function CeaseFire(Controller C, bool bWasAltFire)
{
    Super(VehicleWeapon).CeaseFire(C, bWasAltFire);
}

// Matt: doesn't actually handle MG reload, it just sets the MG to empty and waiting for reload - but redefining this avoids need to redefine the lengthy AttemptFire
function HandleReload()
{
    bClientCanFireMG = false;
    MGReloadState = MG_Empty;
    SetTimer(0.01, false);
}

// Matt: called by ROManualReload from the MG Pawn - sets MGReloadState to MG_Empty, which starts a 4 part reload (tank cannon functionality)
function ServerManualReload()
{
    if( NumMags > 0 && ( MGReloadState == MG_Waiting || MGReloadState == MG_ReadyToFire ) )
    {
        ClientSetReloadState(MG_Empty);
        NetUpdateTime = Level.TimeSeconds - 1;
        MGReloadState = MG_Empty;
        SetTimer(0.01, false);
    }
}

// Matt: part of 4 part reload functionality, based on tank cannon
simulated function ClientSetReloadState( EMGReloadState NewState )
{
    MGReloadState = NewState;
    SetTimer(0.01, false);
}

// Matt: added 4 part reload similar to a tank cannon
simulated function Timer()
{
    local DH_HetzerMountedMGPawn MGP;

    MGP = DH_HetzerMountedMGPawn(Owner);

    // Matt: pause reload if there is the MG has no Controller or if buttoned up or in the process of buttoning or unbuttoning
    if ( MGP == none || MGP.Controller == none || MGP.DriverPositionIndex < MGP.UnbuttonedPositionIndex || MGP.IsInState('ViewTransition') )
        SetTimer(0.05, true);

    else if ( MGReloadState == MG_Empty )
    {
        if (Role == ROLE_Authority)
            PlayOwnedSound(MGReloadSoundOne, SLOT_Misc, 2,, 150,, false); // Matt: doubled the default volume
        else
            PlaySound(MGReloadSoundOne, SLOT_Misc, 2,, 150,, false); // Matt: doubled the default volume

        MGReloadState = MG_ReloadedPart1;
        SetTimer(GetSoundDuration(MGReloadSoundOne), false);
    }

    else if ( MGReloadState == MG_ReloadedPart1 )
    {
        if (Role == ROLE_Authority)
            PlayOwnedSound(MGReloadSoundTwo, SLOT_Misc, 2,, 150,, false);
        else
            PlaySound(MGReloadSoundTwo, SLOT_Misc, 2,, 150,, false);

        MGReloadState = MG_ReloadedPart2;
        SetTimer(GetSoundDuration(MGReloadSoundTwo), false);
    }

    else if ( MGReloadState == MG_ReloadedPart2 )
    {
        if (Role == ROLE_Authority)
            PlayOwnedSound(MGReloadSoundThree, SLOT_Misc, 2,, 150,, false);
        else
            PlaySound(MGReloadSoundThree, SLOT_Misc, 2,, 150,, false);

        MGReloadState = MG_ReloadedPart3;
        SetTimer(GetSoundDuration(MGReloadSoundThree), false);
   }

   else if ( MGReloadState == MG_ReloadedPart3 )
   {
        if (Role == ROLE_Authority)
            PlayOwnedSound(MGReloadSoundFour, SLOT_Misc, 2,, 150,, false);
        else
            PlaySound(MGReloadSoundFour, SLOT_Misc, 2,, 150,, false);

        MGReloadState = MG_ReloadedPart4;
        SetTimer(GetSoundDuration(MGReloadSoundFour), false);
    }

    else if ( MGReloadState == MG_ReloadedPart4 )
    {
        if(Role == ROLE_Authority)
        {
            bClientCanFireMG = true;
            NumMags--;
            MainAmmoCharge[0] = InitialPrimaryAmmo;
        }

        MGReloadState = MG_ReadyToFire;
        SetTimer(0.0, false);
    }
}

defaultproperties
{
     NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
     MGReloadSoundOne=Sound'Inf_Weapons_Foley.mg34.mg34_reload01_000'
     MGReloadSoundTwo=Sound'Inf_Weapons_Foley.mg34.mg34_reload02_039'
     MGReloadSoundThree=Sound'Inf_Weapons_Foley.mg34.mg34_reload03_104'
     MGReloadSoundFour=Sound'Inf_Weapons_Foley.mg34.mg34_reload04_170'
     bClientCanFireMG=true
     MGReloadState=MG_ReadyToFire
     NumMags=12
     FireAttachBone="gunner_int"
     FireEffectOffset=(Y=6.000000)
     DummyTracerClass=class'DH_Vehicles.DH_MG34VehicleClientTracer'
     mTracerInterval=0.495867
     VehHitpoints(0)=(PointRadius=8.000000,PointScale=1.000000,PointBone="loader_attachment",PointOffset=(X=12.500000,Y=6.000000,Z=43.000000))
     VehHitpoints(1)=(PointRadius=17.000000,PointScale=1.000000,PointBone="loader_attachment",PointOffset=(X=5.000000,Y=6.000000,Z=18.500000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     YawStartConstraint=0.000000
     YawEndConstraint=65535.000000
     PitchBone="Gun"
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="loader_attachment"
     WeaponFireOffset=3.000000
     RotationsPerSecond=0.500000
     bInstantFire=false
     Spread=0.002000
     FireInterval=0.070580
     AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
     FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
     AmbientSoundScaling=5.000000
     FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
     ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
     ShakeRotMag=(X=25.000000,Y=0.000000,Z=10.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeOffsetMag=(X=0.500000,Y=0.000000,Z=0.200000)
     ShakeOffsetRate=(X=500.000000,Y=500.000000,Z=500.000000)
     AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.000000,RefireRate=0.070580)
     CustomPitchUpLimit=2100
     CustomPitchDownLimit=63100
     BeginningIdleAnim="loader_idle_close"
     InitialPrimaryAmmo=50
     Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_mg'
     Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body'
     Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
     Skins(2)=Texture'Weapons3rd_tex.German.mg34_world'
     bCollideActors=true
     bBlockActors=true
     bProjTarget=true
     bBlockZeroExtentTraces=true
     bBlockNonZeroExtentTraces=true
}

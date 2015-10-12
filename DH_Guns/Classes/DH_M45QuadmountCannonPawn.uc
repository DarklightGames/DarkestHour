//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountCannonPawn extends DHATGunCannonPawn;

// Modified to switch fire button functionality to alt fire
function Fire(optional float F)
{
    if (!CanFire() || Gun == none)
    {
        return;
    }

    if (Gun.ReadyToFire(true))
    {
        // Although we're always going to alt fire, we need to make it think bWeaponIsFiring & not bWeaponIsAltFiring
        // Otherwise PlayerController will call cease fire stufff, because we aren't holding down the alt fire button
        VehicleFire(false); // sets bWeaponIsFiring = true on server
        bWeaponIsFiring = true;

        if (IsHumanControlled())
        {
            Gun.ClientStartFire(Controller, true);
        }
    }
    // Dry-fire sound if trying to fire empty MG
    else if (Gun.FireCountdown <= Gun.AltFireInterval && Cannon != none) // means that MG isn't reloading (or at least has virtually completed its reload)
    {
        PlaySound(Cannon.NoMGAmmoSound, SLOT_None, 1.5,, 25.0,, true);
    }
}

function AltFire(optional float F)
{
}

exec function SetAltFireOffset(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth) // TEMP
{
    local vector OldAltFireOffset;
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Gun != none)
    {
        OldAltFireOffset = Gun.AltFireOffset;

        if (bScaleOneTenth)
        {
            Gun.AltFireOffset.X = float(NewX) / 10.0;
            Gun.AltFireOffset.Y = float(NewY) / 10.0;
            Gun.AltFireOffset.Z = float(NewZ) / 10.0;
        }
        else
        {
            Gun.AltFireOffset.X = NewX;
            Gun.AltFireOffset.Y = NewY;
            Gun.AltFireOffset.Z = NewZ;
        }

        for (i = 0; i < 4; ++i)
        {
            DH_M45QuadmountCannon(Gun).BarrelEffectEmitter[i].SetRelativeLocation(Gun.AltFireOffset);
        }
        Log(Tag @ "AltFireOffset =" @ Gun.AltFireOffset @ "(was " @ OldAltFireOffset $ ")");
    }
}

exec function SetSpread(float NewValue) // TEMP
{
    Gun.AltFireSpread = NewValue;
    Log("AltFireSpread =" @ Gun.AltFireSpread);
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_M45QuadmountCannon'
    CannonScopeOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    OverlayCenterSize=1.0
    AltAmmoReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=6.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="lookover_up",bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=0.0,Y=0.0,Z=14.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0.0,Y=0.0,Z=14.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=0.0,Y=0.0,Z=-13.0)
    DriveAnim="Vt3485_driver_idle_close"
    CameraBone="Gun"
    bHasAltFire=true
    bHasFireImpulse=false
    RotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Bofors40mmCannonPawn extends DHATGunCannonPawn;

// Modified to animate the traverse & elevation controls, if gun yaw or pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && DH_Bofors40mmCannon(Gun) != none)
    {
        DH_Bofors40mmCannon(Gun).UpdateControlsRotation();
    }
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_Bofors40mmCannon'
    DriverPositions(0)=(ViewFOV=72.0,TransitionUpAnim="com_open",bExposed=true) // FOV represents focused view, like ironsights, not magnified optics
    DriverPositions(1)=(TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VUC_driver_idle_open"
    CameraBone="Camera_com"
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag' // TODO: get ammo icon made (either a clip of 4 rounds, or maybe two clips of 4 rounds stacked one on top of other)
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
}

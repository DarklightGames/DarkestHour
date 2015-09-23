//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountCannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    OverlayCenterSize=1.0
    CannonScopeOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    RaisedPositionIndex=2
    DriverPositions(0)=(ViewLocation=(X=30.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_M45QuadmountCannon'
    CameraBone="Camera_com"
    DriveAnim="Vt3485_driver_idle_close"
    DrivePos=(X=3.0,Y=0.0,Z=4.0)
}

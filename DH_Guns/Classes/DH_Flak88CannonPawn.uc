//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak88CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    bShowRangeText=true
    OverlayCenterSize=0.961
    OverlayCorrectionX=-3
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Artillery.Flak36_sight_background'
    WeaponFov=18.0
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
    DriverPositions(0)=(ViewLocation=(X=70.0,Y=20.0,Z=5.0),ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=15474,ViewPitchDownLimit=64990,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flak88Cannon'
    CameraBone="Gun"
    DrivePos=(X=18.0,Y=-4.0,Z=-11.0)
    DriveAnim="VHalftrack_Rider6_idle"
    EntryRadius=325.0
    SoundVolume=100
}

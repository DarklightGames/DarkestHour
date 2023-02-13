//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flak88CannonPawn extends DHATGunCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Flak88Cannon'
    DriverPositions(0)=(ViewLocation=(X=70.0,Y=20.0,Z=5.0),ViewFOV=21.25,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=15474,ViewPitchDownLimit=64990,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=18.0,Y=-4.0,Z=-11.0)
    DriveAnim="VHalftrack_Rider6_idle"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.Flak36_sight_background'
    GunsightSize=0.823 // 17.5 degrees visible FOV at 4x magnification (ZF20e sight)
    OverlayCorrectionX=-3
    RangePositionX=0.02
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
}

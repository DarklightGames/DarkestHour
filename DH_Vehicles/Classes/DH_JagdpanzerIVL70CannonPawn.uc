//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL70CannonPawn extends DH_JagdpanzerIVL48CannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVL70Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int')
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
    FireImpulse=(X=-110000.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVL48CannonPawn extends DH_JagdpanzerIVCannonPawn;

defaultproperties
{
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int')
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVL48Cannon'
}

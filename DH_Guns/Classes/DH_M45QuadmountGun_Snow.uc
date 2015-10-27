//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountGun_Snow extends DH_M45QuadmountGun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M45QuadmountMGPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling38_dest' // TODO: make M45 destroyed static mesh, winter version
    Skins(0)=texture'DH_Artillery_tex.m45.m45_trailer_snow'
}

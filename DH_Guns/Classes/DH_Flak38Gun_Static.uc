//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Gun_Static extends DH_Flak38Gun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn_Static')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_static_dest' 
    ExitPositions(1)=(X=-30.0,Y=70.0,Z=50.0)
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_static'
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun'
    VehicleHudImage=texture'DH_Artillery_tex.ATGun_Hud.flak38_body_static'
}

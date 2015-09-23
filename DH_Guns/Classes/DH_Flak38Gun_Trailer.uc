//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Gun_Trailer extends DH_Flak38Gun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn_Trailer')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_trailer_dest'
    VehicleHudImage=texture'DH_Artillery_tex.ATGun_Hud.flak38_body_trailer'
    ExitPositions(1)=(X=-30.0,Y=85.0,Z=50.0)
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_trailer'
    Skins(1)=texture'DH_Artillery_tex.Flak38.Flak38_trailer'
}

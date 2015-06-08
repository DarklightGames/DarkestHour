//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Pak40ATGunLate_CamoOne extends DH_Pak40ATGun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak40CannonPawnLate_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_dest_camo'
    Skins(0)=texture'DH_Artillery_Tex.Pak40.Pak40'
}

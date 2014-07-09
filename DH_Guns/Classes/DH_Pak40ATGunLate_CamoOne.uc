//==============================================================================
// DH_Pak40ATGunLate_CamoOne
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German 7.5 cm Panzerabwehrkanone 40 - camo 1 variant
//==============================================================================
class DH_Pak40ATGunLate_CamoOne extends DH_Pak40ATGun;

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Pak40CannonPawnLate_CamoOne')
     DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_destroyedB'
     Skins(0)=Texture'DH_Artillery_Tex.Pak40.Pak40'
}

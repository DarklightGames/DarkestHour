//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Spitfire_Airplane extends DHAirplane;

defaultproperties
{
    AirplaneName="Supermarine Spitfire"
    Mesh=Mesh'DH_Airplanes_anm.Spitfire'
    LeftWeaponInfos(0)=(WeaponClass=class'DHHS404CannonWeapon',WeaponBone="cannon.001")
    RightWeaponInfos(0)=(WeaponClass=class'DHHS404CannonWeapon',WeaponBone="cannon.002")
}


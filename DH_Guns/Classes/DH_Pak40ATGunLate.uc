//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Pak40ATGunLate extends DH_Pak40ATGun; // late war version with much less ammo

#exec OBJ LOAD FILE=..\Animations\DH_Pak40_anm.ukx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak40CannonPawnLate')
}

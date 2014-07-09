//==============================================================================
// DH_Pak40ATGunLate
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German 7.5 cm Panzerabwehrkanone 40 - reduced ammo
//==============================================================================
class DH_Pak40ATGunLate extends DH_Pak40ATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Pak40_anm.ukx

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Pak40CannonPawnLate')
}

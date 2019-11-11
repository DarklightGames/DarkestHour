//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BF109_Airplane extends DHAirplane;

defaultproperties
{
    AirplaneName="Messerschmitt Bf 109"
    CenterWeaponInfos(0)=(WeaponClass=class'DHMG151CannonWeapon')
    CenterWeaponInfos(1)=(WeaponClass=class'DHSC250BombWeapon',WeaponBone="bomb.002",LocationOffset=(X=0.0,y=0.0,Z=-5.0))
}

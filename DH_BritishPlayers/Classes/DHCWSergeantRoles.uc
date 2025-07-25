//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWSergeantRoles extends DHAlliedSergeantRoles
    abstract;

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    PrimaryWeapons(0)=(Item=Class'DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=Class'DH_M1928_20rndWeapon')
    PrimaryWeapons(2)=(Item=Class'DH_M1928_30rndWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_EnfieldNo2Weapon')
    Grenades(0)=(Item=Class'DH_MillsBombWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
    Grenades(2)=(Item=Class'DH_RedSmokeWeapon')
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.brit_sleeves'
}

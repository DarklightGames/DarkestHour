//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWTankCrewmanRoles extends DHAlliedTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=Class'DH_StenMkIIIWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_EnfieldNo2Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemAllied"
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
}

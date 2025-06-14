//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSTankCrewmanRoles extends DHAlliedTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_GreaseGunWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemAllied"
    Headgear(0)=Class'DH_USTankerHat'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.US_sleeves'
}

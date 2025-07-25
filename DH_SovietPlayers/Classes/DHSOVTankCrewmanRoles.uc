//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSOVTankCrewmanRoles extends DHAlliedTankCrewmanRoles
    abstract;

defaultproperties
{
    AltName="Ekipazh tanka"
    PrimaryWeapons(0)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    SleeveTexture=Texture'Weapons1st_tex.RussianTankerSleeves'
    DetachedArmClass=Class'SeveredArmSovTanker'
    DetachedLegClass=Class'SeveredLegSovTanker'
    Headgear(0)=Class'DH_SovietTankerHat'
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
}

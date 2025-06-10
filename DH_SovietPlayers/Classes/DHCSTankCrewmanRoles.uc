//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCSTankCrewmanRoles extends DHAlliedTankCrewmanRoles //WIP; to do: radio voices, uniforms
    abstract;

defaultproperties
{
    AltName="Tankista"
    PrimaryWeapons(0)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=Class'SeveredArmSovTanker'
    DetachedLegClass=Class'SeveredLegSovTanker'
    Headgear(0)=Class'DH_SovietTankerHat'
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
}

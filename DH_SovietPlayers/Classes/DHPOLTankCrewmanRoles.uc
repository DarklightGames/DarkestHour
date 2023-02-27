//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPOLTankCrewmanRoles extends DHAlliedTankCrewmanRoles
    abstract;

defaultproperties
{
    AltName="Czolgista"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovTanker'
    DetachedLegClass=class'ROEffects.SeveredLegSovTanker'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietTankerHat'
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
}

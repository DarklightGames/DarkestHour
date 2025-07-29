//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPOLRadioOperatorRoles extends DHAlliedRadioOperatorRoles
    abstract;

defaultproperties
{
    AltName="Radzista"
    PrimaryWeapons(0)=(Item=Class'DH_MN9130Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    Backpacks(0)=(BackpackClass=Class'DH_SovRadioBackpack')
}

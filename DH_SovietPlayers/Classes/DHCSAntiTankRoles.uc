//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCSAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Protitankovy strelec"
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    PrimaryWeapons(0)=(Item=Class'DH_PTRDWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"  //to do: replace with RPG-40
    GlovedHandTexture=Texture'DHBritishCharactersTex.Winter.hands_BRITgloves'
}

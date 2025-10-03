//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPOLAssaultRoles extends DHAlliedAssaultRoles
    abstract;

defaultproperties
{
    AltName="Szturmowiec"
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_Russian"
}

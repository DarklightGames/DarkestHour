//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSOVCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    MyName="Fireteam Leader"
    AltName="Komandir Zvena"
    PrimaryWeapons(0)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_RDG1SmokeGrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
}

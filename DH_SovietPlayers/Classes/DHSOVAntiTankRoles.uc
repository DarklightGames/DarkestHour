//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSOVAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Broneboyschik"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    //removed m38 as an option because this is usually a strategically important role, if someone will take it and "waste" by taking non-PTRD weapon, this will damage the whole team
    //i recommend adding m38 manually only on late war maps where PTRD should be in abundance and less effective against tanks (together with higher role limit)
    PrimaryWeapons(0)=(Item=Class'DH_PTRDWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_TT33Weapon')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

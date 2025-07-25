//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPOLAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Strzelec przeciwpancerny"
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    //removed m38 as an option because this is usually a strategically important role, if someone will take it and "waste" by taking non-PTRD weapon, this will damage the whole team
    //i recommend adding m38 manually only on late war maps where PTRD should be in abundance and less effective against tanks (together with higher role limit)
    PrimaryWeapons(0)=(Item=Class'DH_PTRDWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"  //to do: replace with RPG-40
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
}

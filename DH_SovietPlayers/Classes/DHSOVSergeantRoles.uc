//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHSOVSergeantRoles extends DHAlliedSergeantRoles
    abstract;

defaultproperties
{
    MyName="Squad leader"
    PluralName="Squad leaders"
    AltName="Komandir otdeleniya"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT38Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

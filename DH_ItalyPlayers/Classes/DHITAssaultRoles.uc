//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHITAssaultRoles extends DHAxisAssaultRoles
    abstract;

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Camicie Nere"  // "Blackshirts"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MAB38Weapon')   // TODO: would be nice to have a pouch for the MABs!
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon',AssociatedAttachment=class'DH_Weapons.DH_BerettaM1934AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_SRCMMod35GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon')
    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet_Blackshirt'
    HeadgearProbabilities(0)=1.0
    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_Italian"
}

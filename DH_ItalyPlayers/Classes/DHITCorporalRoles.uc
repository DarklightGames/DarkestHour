//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHITCorporalRoles extends DHAxisCorporalRoles
    abstract;

defaultproperties
{
    AltName="Caporale"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    // TODO: Add the Carbine Carcano M91/38
    Grenades(0)=(Item=class'DH_Weapons.DH_SRCMMod35GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon')
    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'
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

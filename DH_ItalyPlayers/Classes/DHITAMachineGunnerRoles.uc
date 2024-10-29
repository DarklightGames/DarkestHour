//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITAMachineGunnerRoles extends DHAxisMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Mitragliere"
    AddedRoleRespawnTime=10 //Lower respawn timer than BAR and Bren roles since the Breda is arguably the least effective MG in the game.

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Breda30Weapon',AssociatedAttachment=class'DH_Weapons.DH_Breda30AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon',AssociatedAttachment=class'DH_BerettaM1934AmmoPouch')

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'
    Headgear(2)=class'DH_ItalyPlayers.DH_ItalianHelmet_Adrian'
    Headgear(3)=class'DH_ItalyPlayers.DH_ItalianHelmet_AdrianTwo'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.05
    HeadgearProbabilities(3)=0.05

    Backpack(0)=(BackpackClass=class'DH_Equipment.DH_Breda30Backpack')
    
    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}
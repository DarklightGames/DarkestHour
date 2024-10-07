//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DHUSMadManRoles extends DHAlliedRiflemanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Equipment.DHBrokenBottleItem')
    Grenades(0)=(Item=class'DH_Weapons.DH_GLWeapon')

    Headgear(0)=class'DH_Halloween_3rd_anm.MadHat"
    HeadgearProbabilities(0)=0.9
    
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
   
    MyName="Mad Man"
    AltName="Mad Man"
    Article="a "
    PluralName="Mad Men"
    
    bCanPickupWeapons=false
}

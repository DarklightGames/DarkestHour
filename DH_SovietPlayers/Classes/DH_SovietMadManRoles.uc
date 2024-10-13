//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DH_SovietMadManRoles extends DHAlliedRiflemanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Equipment.DHBrokenBottleItem')
    Grenades(0)=(Item=class'DH_Weapons.DH_GLWeapon')

    HeadgearProbabilities(0)=1
    Headgear(0)=class'DH_SovietPlayers.DH_MadTopHat'

    SleeveTexture=Texture'DHSovietCharactersTex.Sleeves.NavalSleeves2'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
   
    MyName="Mad Man"
    AltName="Mad Man"
    Article="the "
    PluralName="Mad Men"
    
    bCanPickupWeapons=false
}

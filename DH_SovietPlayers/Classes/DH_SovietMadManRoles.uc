//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SovietMadManRoles extends DHAlliedRiflemanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DHBrokenBottleItem')

    HeadgearProbabilities(0)=1
    Headgear(0)=Class'DH_MadTopHat'

    SleeveTexture=Texture'DHSovietCharactersTex.Sleeves.NavalSleeves2'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
   
    MyName="Mad Man"
    AltName="Mad Man"
    Article="the "
    PluralName="Mad Men"
    
    bCanPickupWeapons=false
}

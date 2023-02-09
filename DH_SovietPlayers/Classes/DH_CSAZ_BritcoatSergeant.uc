//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZ_BritcoatSergeant extends DHCSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_CSAZbritcoatSLPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_CSAZSidecap'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Coat_Sleeves'
    
    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.1
}

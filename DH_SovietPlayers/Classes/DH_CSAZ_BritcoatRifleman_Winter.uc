//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZ_BritcoatRifleman_Winter extends DHCSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_CSAZbritcoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_CSAZbritcoatSidorPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_CSAZFurHatUnfolded'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Coat_Sleeves'
    HandType=Hand_Gloved
}

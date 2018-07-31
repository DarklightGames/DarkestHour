//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_USOfficer82nd extends DHUSArtilleryOfficerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USAB82ndPawn',Weight=1.0)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndOfficera'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndOfficerb'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USRifleman1stIDSicily extends DHUSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_US1stIDSicilyPawn',Weight=5.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_US1stIDSicilyBeachPawn',Weight=1.0)
    
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_HBT_Light_sleeves'

    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'

    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.7
}

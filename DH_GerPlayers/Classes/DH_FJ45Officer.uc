//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_FJ45Officer extends DHGEArtilleryOfficerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanOfficerArdennesFJPawn')
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}

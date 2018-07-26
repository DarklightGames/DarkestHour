//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_LWOfficer extends DHGEArtilleryOfficerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanLuftwaffePawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_LWHelmet'
    Headgear(1)=class'DH_GerPlayers.DH_LWHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}

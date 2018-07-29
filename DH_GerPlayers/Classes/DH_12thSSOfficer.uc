//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_12thSSOfficer extends DHGEArtilleryOfficerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_German12thSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G41Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
}

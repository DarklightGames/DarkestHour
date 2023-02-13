//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WHFireteamLeaderC extends DHGECorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanCamoHeerPawn',Weight=4.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanCamoHeerPawnB',Weight=4.0)
    RolePawns(2)=(PawnClass=class'DH_GerPlayers.DH_GermanSniperHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
}

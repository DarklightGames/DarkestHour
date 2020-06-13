//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_WHSquadLeaderC extends DHGESergeantRoles;

defaultproperties
{

    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_visWeapon')
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanCamoHeerPawn',Weight=8.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSniperHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}

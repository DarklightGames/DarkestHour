//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WSSFireteamLeader extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanSSPawnC',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSpringSmockSSPawnC',Weight=2.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.DotGreenSleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_M712Weapon')
}

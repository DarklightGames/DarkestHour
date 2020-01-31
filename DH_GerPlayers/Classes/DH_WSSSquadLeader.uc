//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_WSSSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    AltName="Scharführer"

    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_BHPWeapon')

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSpringSmockSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}

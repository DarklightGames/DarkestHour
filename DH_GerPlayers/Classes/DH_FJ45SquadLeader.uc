//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_FJ45SquadLeader extends DHGESergeantRoles;

defaultproperties
{

    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
}

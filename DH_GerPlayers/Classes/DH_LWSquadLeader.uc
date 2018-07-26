//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_LWSquadLeader extends DHGESergeantRoles;

defaultproperties
{

    Headgear(0)=class'DH_GerPlayers.DH_LWHelmet'
    Headgear(1)=class'DH_GerPlayers.DH_LWHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
}

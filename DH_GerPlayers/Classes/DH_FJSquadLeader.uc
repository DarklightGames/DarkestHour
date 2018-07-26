//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_FJSquadLeader extends DHGESergeantRoles;

defaultproperties
{

    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamoOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamoTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_FG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
}

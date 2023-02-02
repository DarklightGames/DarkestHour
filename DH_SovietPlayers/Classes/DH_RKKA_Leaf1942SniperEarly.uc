//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_Leaf1942SniperEarly extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietLeaf1942Pawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.Leaf1942Sleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedPEWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40ScopedWeapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')  
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_Nagant1895BramitWeapon')
}

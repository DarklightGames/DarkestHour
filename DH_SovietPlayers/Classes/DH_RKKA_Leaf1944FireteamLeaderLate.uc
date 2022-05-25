//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_Leaf1944FireteamLeaderLate extends DHSOVCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietLeaf1944Pawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.Leaf1944Sleeves'

    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_LWP_StandardFireteamLeaderLate extends DHPOLCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicNocoatLatePawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
}

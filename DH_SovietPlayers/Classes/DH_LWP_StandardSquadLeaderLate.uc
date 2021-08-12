//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWP_StandardSquadLeaderLate extends DHPOLSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLatePawnB',Weight=2.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLatePawnC',Weight=2.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLatePawnM35',Weight=2.0)

    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'
    Headgear(1)=class'DH_SovietPlayers.DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_AVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

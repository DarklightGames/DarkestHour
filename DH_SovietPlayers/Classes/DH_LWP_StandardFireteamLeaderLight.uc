//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_LWP_StandardFireteamLeaderLight extends DHPOLCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLightPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLightPawnB',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLLightPawnC',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'
    Headgear(1)=class'DH_SovietPlayers.DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_light_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_ViSWeapon')
}

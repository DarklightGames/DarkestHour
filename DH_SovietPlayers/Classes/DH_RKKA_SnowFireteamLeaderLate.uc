//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_SnowFireteamLeaderLate extends DHSOVCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowLatePawn',Weight=1.0)
    DetachedArmClass=class'ROEffects.SeveredArmSovSnow'
    DetachedLegClass=class'ROEffects.SeveredLegSovSnow'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_whitegloves'
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
}

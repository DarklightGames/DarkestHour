//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_LWP_GreatcoatAssault extends DHPOLAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatBrownBagPawn',Weight=10.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatGreyBagPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSh41Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

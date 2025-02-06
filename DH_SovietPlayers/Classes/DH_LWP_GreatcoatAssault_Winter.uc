//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatAssault_Winter extends DHPOLAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatBrownBagPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatBrownPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSh41Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    HandType=Hand_Gloved
}

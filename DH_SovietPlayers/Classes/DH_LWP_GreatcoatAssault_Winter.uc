//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatAssault_Winter extends DHPOLAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPGreatcoatBrownBagPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPGreatcoatBrownPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_LWPHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.DH_LWPCoatSleeves'
    PrimaryWeapons(2)=(Item=Class'DH_PPSh41Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    HandType=Hand_Gloved
}

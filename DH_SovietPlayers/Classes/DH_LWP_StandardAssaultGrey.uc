//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardAssaultGrey extends DHPOLAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicMixGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicBackpackGreyPawn',Weight=2.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicGreyPawn',Weight=2.0)
    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.LWP_grey_sleeves'

    PrimaryWeapons(2)=(Item=Class'DH_PPSh41Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}

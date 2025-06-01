//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardAssaultGrey extends DHPOLAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicMixGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicBackpackGreyPawn',Weight=2.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicGreyPawn',Weight=2.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSh41Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

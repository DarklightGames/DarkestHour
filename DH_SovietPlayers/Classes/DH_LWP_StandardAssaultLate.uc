//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardAssaultLate extends DHPOLAssaultRoles;

defaultproperties
{

    RolePawns(0)=(PawnClass=Class'DH_LWPTunicBackpackLatePawn',Weight=4.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicNocoatLatePawn',Weight=3.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicLatePawn',Weight=3.0)
    RolePawns(3)=(PawnClass=Class'DH_LWPTunicMixLatePawn',Weight=1.0)


    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    PrimaryWeapons(2)=(Item=Class'DH_PPSh41Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}

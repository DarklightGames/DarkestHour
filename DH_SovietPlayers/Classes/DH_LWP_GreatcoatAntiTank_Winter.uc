//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatAntiTank_Winter extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPGreatcoatBrownBagPawn_Winter',Weight=5.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPGreatcoatGreyBagPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_LWPHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
    HandType=Hand_Gloved
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKF_SquadLeaderPacific extends DHSOVSergeantRoles; //this role wears a naval cap, which has a different writing on it depending on the fleet, so this role is separated on fleets

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietMarineBushlatPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietNavalCap_Pacific'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.NavalSleeves2'

    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}

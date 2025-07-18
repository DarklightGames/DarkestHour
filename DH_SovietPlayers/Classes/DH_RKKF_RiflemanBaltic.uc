//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKF_RiflemanBaltic extends DHSOVRiflemanRoles; //this role wears a naval cap, which has a different writing on it depending on the fleet, so this role is separated on fleets

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietMarineBushlatPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietNavalCap_Baltic'
    SleeveTexture=Texture'DHSovietCharactersTex.NavalSleeves2'
}

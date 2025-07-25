//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKF_AntiTank extends DHSOVAntiTankRoles; //wears helmet and no naval cap, so doesnt need to be separated on fleets for an appropriate cap

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietMarineBushlatNoBeltPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.NavalSleeves2'
}

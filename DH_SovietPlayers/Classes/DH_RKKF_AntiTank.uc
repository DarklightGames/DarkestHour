//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKF_AntiTank extends DHSOVAntiTankRoles; //wears helmet and no naval cap, so doesnt need to be separated on fleets for an appropriate cap

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietMarineBushlatNoBeltPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.NavalSleeves2'
}

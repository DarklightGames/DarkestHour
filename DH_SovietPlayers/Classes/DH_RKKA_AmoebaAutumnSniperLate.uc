//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaAutumnSniperLate extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaAutumnLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.AmoebaSleeves'
    Headgear(0)=Class'DH_SovietSidecap'
    
    SecondaryWeapons(0)=(Item=Class'DH_TT33Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_Nagant1895BramitWeapon')
}

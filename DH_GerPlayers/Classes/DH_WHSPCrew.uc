//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHSPCrew extends DHGETankCrewmanRoles;

defaultproperties
{
    MyName="Assault Gun Crewman"
    AltName="Stugbesatzung"

    RolePawns(0)=(PawnClass=Class'DH_GermanSPGunCrewPawn')
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    Headgear(0)=Class'ROGermanHat'
    Headgear(1)=Class'DH_HeerCamoCap'
}

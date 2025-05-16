//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZombieLeaderPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_Engine.DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_TankCrew'

    Skins(0)=Texture'DHEventCharactersTex.GetTunics.h_zombie'
    Skins(1)=Texture'DHEventCharactersTex.GerHeads.h_face_zombie'

    bReversedSkinsSlots=false

    ShovelClass=class'DH_Equipment.DHShovelItem_German'
    BinocsClass=class'DH_Equipment.DHBinocularsItemGerman'

    GroundSpeed=250
    WalkingPct=0.3
    Health=500
    Stamina=500
    MinHurtSpeed=700.0
    bNeverStaggers=true
    bAlwaysSeverBodyparts=true

    Hitpoints(1)=(DamageMultiplier=4.0) // head

    HealthFigureClass=class'DH_GerPlayers.DHHealthFigure_Germany'
}

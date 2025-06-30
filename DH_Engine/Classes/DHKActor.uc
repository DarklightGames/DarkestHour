//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHKActor extends KActor
    placeable;

defaultproperties
{
    bNoDelete=false
    StaticMesh=StaticMesh'DH_Artillery_stc.M5_shell_case'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KLinearDamping=0.1
        KAngularDamping=0.5
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=true
        bKDoubleTickRate=false
        bDestroyOnWorldPenetrate=false
        bDoSafetime=true
        KFriction=0.75
        KImpactThreshold=700.0
        KMass=0.1
    End Object
    KParams=KParams0
}


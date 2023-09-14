//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHKActor extends KActor
    placeable;

defaultproperties
{
    bNoDelete=false
    StaticMesh=StaticMesh'DH_Artillery_stc.M5.M5_shell_case'

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
    KParams=KarmaParamsRBFull'DHKActor.KParams0'
}


//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHRadioHQAttachment extends Actor;

var byte           TeamIndex;

var DHRadio        Radio;
var class<DHRadio> RadioClass;
var Vector         RadioOffset;

simulated function MakeVisible();
simulated function MakeInvisible() { GotoState('Invisible'); }

function Setup()
{
    if (Radio == none)
    {
        Radio = Spawn(RadioClass, self);
    }

    if (Radio != none)
    {
        Radio.TeamIndex = TeamIndex;
        Radio.SetBase(self);
        Radio.SetRelativeLocation(RadioOffset);
        Radio.bShouldShowOnSituationMap = false;
    }
    else
    {
        Warn("Failed to spawn a radio!");
    }
}

simulated function Destroyed()
{
    if (Radio != none)
    {
        Radio.Destroy();
    }
}

simulated state Invisible
{
    simulated function MakeVisible() { GotoState(''); }
    simulated function MakeInvisible();

    simulated function BeginState()
    {
        if (Radio != none)
        {
            Radio.bHidden = true;
            Radio.AmbientSound = none;
        }

        bHidden = true;
    }

    simulated function EndState()
    {
        if (Radio != none)
        {
            Radio.bHidden = false;
            Radio.AmbientSound = Radio.default.AmbientSound;
        }

        bHidden = false;
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    RemoteRole=ROLE_DumbProxy

    NetUpdateFrequency=10.0
    bAlwaysRelevant=true
    bOnlyDirtyReplication=true

    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true
    bPathColliding=true
    bWorldGeometry=true

    StaticMesh=StaticMesh'DH_Construction_stc.GER_Artillery_Radio'

    RadioClass=Class'DHRadio'
    RadioOffset=(Y=-10,Z=64)
}

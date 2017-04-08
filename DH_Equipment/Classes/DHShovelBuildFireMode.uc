//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHShovelBuildFireMode extends WeaponFire;

var DHConstruction Construction;
var float TraceDistanceInMeters;

// Modified to check (via a trace) that player is facing an obstacle that can be cut & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local vector         HitLocation, HitNormal;
    local Actor HitActor;

    HitActor = Trace(HitLocation, HitNormal, Weapon.Location + (class'DHUnits'.static.MetersToUnreal(default.TraceDistanceInMeters) * vector(Weapon.Rotation)), Weapon.Location, true);

    Construction = DHConstruction(HitActor);

    if (Construction != none &&
        (Construction.GetTeamIndex() == NEUTRAL_TEAM_INDEX || Construction.GetTeamIndex() == Instigator.GetTeamNum()) &&
        Construction.CanBeBuilt() &&
        Instigator != none &&
        !Instigator.IsProneTransitioning() &&
        Instigator.Velocity == vect(0.0, 0.0, 0.0))
    {
        return true;
    }

    return false;
}

event ModeDoFire()
{
    if (AllowFire())
    {
        // TODO: get the exact construction we're lookin' at

        GotoState('Building');
    }
}

state Building
{
    simulated function BeginState()
    {
        PlayFiring();
    }

    simulated function PlayFiring()
    {
        if (Weapon != none && Weapon.HasAnim(FireAnim))
        {
            Weapon.PlayAnim(FireAnim, FireAnimRate);

            SetTimer(Weapon.GetAnimDuration(FireAnim), false);
        }
    }

    simulated function bool AllowFire()
    {
        return false;
    }

    event EndState()
    {
        if (Construction != none)
        {
            Construction.ServerIncrementProgress();
        }
        // TODO: add health to the construction?
    }

    function Timer()
    {
        SetInitialState();
    }
}

defaultproperties
{
    TraceDistanceInMeters=2.0

    bModeExclusive=true
    bFireOnRelease=false

    FireAnim="dig"
}


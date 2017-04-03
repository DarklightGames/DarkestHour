//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHShovelBuildFireMode extends WeaponFire;

// Modified to check (via a trace) that player is facing an obstacle that can be cut & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local DHConstruction Construction;
    local vector         HitLocation, HitNormal;
    local Actor HitActor;

    HitActor = Trace(HitLocation, HitNormal, Weapon.Location + (100.0 * vector(Weapon.Rotation)), Weapon.Location, true);

    Construction = DHConstruction(HitActor);

    // TODO: do a check that the construction can be built up

    if (Construction != none &&
        Construction.GetTeamIndex() == Instigator.GetTeamNum() &&
        Construction.CanBeBuilt() &&
        Instigator != none &&
        !Instigator.IsProneTransitioning() &&
        Instigator.Velocity == vect(0.0, 0.0, 0.0))
    {
        Log("can be built!");

        return true;
    }

    return false;
}

event ModeDoFire()
{
    if (AllowFire())
    {
        Log("doing to state!");

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
        // TODO: add health to the construction?
    }

    function Timer()
    {
        SetInitialState();
    }
}

defaultproperties
{
    bModeExclusive=true
    bFireOnRelease=false

    FireAnim="dig"
    FireLoopAnim="dig"
}

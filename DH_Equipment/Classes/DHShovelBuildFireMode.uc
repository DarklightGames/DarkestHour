//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelBuildFireMode extends DHWeaponFire;

var     DHConstruction  Construction;          // reference to the Construction actor we're building
var     float           TraceDistanceInMeters; // player has to be within this distance of a construction to build it

// Modified to check (via a trace) that player is facing an obstacle that can be cut & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local Actor  HitActor;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;

    if (Instigator == none || Instigator.bIsCrawling || Instigator.IsProneTransitioning() || Instigator.Velocity != vect(0.0, 0.0, 0.0))
    {
        return false;
    }

    TraceStart = Weapon.Location;
    TraceEnd = TraceStart + (class'DHUnits'.static.MetersToUnreal(default.TraceDistanceInMeters) * vector(Weapon.Rotation));

    foreach Weapon.TraceActors(class'Actor', HitActor, HitLocation, HitNormal, TraceEnd, TraceStart, vect(32.0, 32.0, 0.0))
    {
        if (HitActor.bStatic && !HitActor.IsA('Volume') && !HitActor.IsA('ROBulletWhipAttachment') || HitActor.IsA('DHConstruction'))
        {
            break;
        }
    }

    Construction = DHConstruction(HitActor);

    return Construction != none &&
           (Construction.GetTeamIndex() == NEUTRAL_TEAM_INDEX || Construction.GetTeamIndex() == Instigator.GetTeamNum()) &&
           Construction.CanBeBuilt();
}

event ModeDoFire()
{
    if (AllowFire())
    {
        GotoState('Building');
        Weapon.IncrementFlashCount(0);
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
            Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);

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
    FireAnimRate=1.0
    FireTweenTime=0.2
}

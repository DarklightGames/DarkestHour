//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelBuildFireMode extends DHWeaponFire;

const SOUND_RADIUS = 32.0;

var     DHConstruction  Construction;          // reference to the Construction actor we're building
var     float           TraceDistanceInMeters; // player has to be within this distance of a construction to build it

// Modified to check (via a trace) that player is facing an obstacle that can be built & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local Actor  HitActor;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;
    local DHPawn Pawn;

    if (Weapon == none ||
        Instigator == none ||
        Instigator.Controller == none ||
        Instigator.bIsCrawling ||
        Instigator.IsProneTransitioning() ||
        Instigator.Velocity != vect(0.0, 0.0, 0.0))
    {
        return false;
    }

    TraceStart = Instigator.Location + Instigator.EyePosition();
    TraceEnd = TraceStart + (class'DHUnits'.static.MetersToUnreal(default.TraceDistanceInMeters) * vector(Instigator.GetViewRotation()));

    foreach Weapon.TraceActors(class'Actor', HitActor, HitLocation, HitNormal, TraceEnd, TraceStart, vect(32.0, 32.0, 0.0))
    {
        if (HitActor != none &&
            HitActor.bStatic &&
            !HitActor.IsA('Volume') &&
            !HitActor.IsA('ROBulletWhipAttachment') ||
            HitActor.IsA('DHConstruction'))
        {
            break;
        }
    }

    Construction = DHConstruction(HitActor);

    if (Construction == none)
    {
        return false;
    }
    
    Pawn = DHPawn(Instigator);

    if (Pawn != none && !Pawn.CanBuildWithShovel())
    {
        return false;
    }

    return  (Construction.GetTeamIndex() == NEUTRAL_TEAM_INDEX || Construction.GetTeamIndex() == Instigator.GetTeamNum()) && Construction.CanBeBuilt();
}

event ModeDoFire()
{
    Construction = none;

    if (AllowFire())
    {
        GotoState('Building');
    }
}

simulated state Building
{
    simulated function BeginState()
    {
        PlayFiring();
    }

    simulated function PlayFiring()
    {
        if (Weapon != none)
        {
            if (Instigator != none && Instigator.Role == ROLE_Authority)
            {
                Weapon.IncrementFlashCount(ThisModeNum);
            }

            if (Weapon.HasAnim(FireAnim))
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }

            SetTimer(Weapon.GetAnimDuration(FireAnim), false);

            // Only play the shoveling sound on non-owning clients since we play
            // the sound using animation events in the first-person weapon
            // for the owning client.
            if (!Instigator.IsLocallyControlled())
            {
                Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,, SOUND_RADIUS,, false);
            }
        }
    }

    simulated function bool AllowFire()
    {
        return false;
    }

    simulated function Timer()
    {
        SetInitialState();
    }

}

simulated function DigDone()
{
    if (Construction != none && Construction.Role == ROLE_Authority)
    {
        Construction.IncrementProgress(Instigator);
    }
}

defaultproperties
{
    TraceDistanceInMeters=2.15
    bModeExclusive=true
    bFireOnRelease=false
    bWaitForRelease=true
    FireAnim="dig"
    FireAnimRate=1.0
    FireTweenTime=0.25
    FireSounds(0)=Sound'DH_WeaponSounds.Shovel.shovel_1'
    FireSounds(1)=Sound'DH_WeaponSounds.Shovel.shovel_3'
    FireSounds(2)=Sound'DH_WeaponSounds.Shovel.shovel_4'
    bIgnoresWeaponLock=true
}

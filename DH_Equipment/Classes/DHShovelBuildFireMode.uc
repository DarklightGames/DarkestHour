//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelBuildFireMode extends DHWeaponFire;

const SOUND_RADIUS = 32.0;

var     float           TraceDistanceInMeters; // player has to be within this distance of a construction to build it

// Modified to check (via a trace) that player is facing an obstacle that can be built & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local DHPawn Pawn;
    
    Pawn = DHPawn(Instigator);

    if (Pawn.Construction == none)
    {
        return false;
    }

    return (Pawn.Construction.GetTeamIndex() == NEUTRAL_TEAM_INDEX || Pawn.Construction.GetTeamIndex() == Instigator.GetTeamNum()) && Pawn.Construction.CanBeBuilt();
}


event ModeDoFire()
{
    // local DHPawn Pawn;
    
    // Pawn = DHPawn(Instigator);
    // Pawn.SetConstructionNone();

    if (AllowFire())
    {
        GotoState('Building');
    }
    else 
    {
        Weapon.StopFire(ThisModeNum);
    }
}

simulated state Building
{
    event ModeDoFire();

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
    local DHPawn Pawn;
    
    Pawn = DHPawn(Instigator);

    if (Pawn.Construction != none && Pawn.Construction.Role == ROLE_Authority)
    {
        Pawn.Construction.IncrementProgress(Instigator);
        if (Pawn.Construction.Progress >= Pawn.Construction.ProgressMax)
        {
            Pawn.SetConstructionNone();
        }
    }
}

defaultproperties
{
    TraceDistanceInMeters=2.15
    bModeExclusive=true
    bFireOnRelease=false
    bWaitForRelease=false
    FireAnim="dig"
    FireAnimRate=1.0
    FireTweenTime=0.25
    FireSounds(0)=Sound'DH_WeaponSounds.Shovel.shovel_1'
    FireSounds(1)=Sound'DH_WeaponSounds.Shovel.shovel_3'
    FireSounds(2)=Sound'DH_WeaponSounds.Shovel.shovel_4'
    bIgnoresWeaponLock=true
}

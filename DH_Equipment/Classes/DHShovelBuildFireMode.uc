//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelBuildFireMode extends DHWeaponFire;

var DHConstruction LookConstruction;
var DHConstruction DigConstruction;

// Modified to check (via a trace) that player is facing an obstacle that can be built & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local DHPawn Pawn;

    Pawn = DHPawn(Instigator);

    if (Pawn != none && !Pawn.CanBuildWithShovel())
    {
        return false;
    }

    LookConstruction = Pawn.TraceConstruction();
    LookConstruction = LookConstruction;

    Pawn.ConstructionToDig = LookConstruction;

    return LookConstruction != none && (LookConstruction.GetTeamIndex() == NEUTRAL_TEAM_INDEX || LookConstruction.GetTeamIndex() == Instigator.GetTeamNum()) && LookConstruction.CanBeBuilt();
}

event ModeDoFire()
{
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
        // Store a reference to the construction we're building.
        DigConstruction = LookConstruction;

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
                const SOUND_RADIUS = 32.0;
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
    if (DigConstruction != none && DigConstruction.Role == ROLE_Authority)
    {
        DigConstruction.IncrementProgress(Instigator);
    }
}

defaultproperties
{
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

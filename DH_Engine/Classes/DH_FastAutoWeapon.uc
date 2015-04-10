//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FastAutoWeapon extends DH_AutoWeapon
    abstract;

// Tells bot whether to charge or back off while using this weapon
function float SuggestAttackStyle()
{
    return 0.7;
}

// Tells bot whether to charge or back off while defending against this weapon
function float SuggestDefenseStyle()
{
    return -0.5;
}

function float MaxRange()
{
    return 4500.0; // about 75 meters
}

simulated function bool StartFire(int Mode)
{
    if (FireMode[Mode].bMeleeMode)
    {
        return super.StartFire(Mode);
    }

    if (!super.StartFire(Mode)) // returns false when mag is empty
    {
       return false;
    }

    if (AmmoAmount(0) <= 0)
    {
        return false;
    }

    AnimStopLooping();

    if (!FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0))
    {
        FireMode[Mode].StartFiring();
        return true;
    }
    else
    {
        return false;
    }

    return true;
}

simulated function AnimEnd(int channel)
{
    if (!FireMode[0].IsInState('FireLoop'))
    {
        super(DHProjectileWeapon).AnimEnd(channel);
    }
}

defaultproperties
{
}

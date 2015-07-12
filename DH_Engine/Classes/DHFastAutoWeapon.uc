//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHFastAutoWeapon extends DHAutoWeapon
    abstract;

simulated function bool StartFire(int Mode)
{
    if (super.StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode)
        {
            return true;
        }

        AnimStopLooping();

        if (!FireMode[Mode].IsInState('FireLoop'))
        {
            FireMode[Mode].StartFiring();

            return true;
        }
    }

    return false;
}

simulated function AnimEnd(int Channel)
{
    if (!FireMode[0].IsInState('FireLoop'))
    {
        super(DHProjectileWeapon).AnimEnd(channel);
    }
}

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

defaultproperties
{
}

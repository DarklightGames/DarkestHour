//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPawnSoundGroup extends ROPawnSoundGroup
    abstract;

var     sound   BurningPainSoundGroup;

static function sound GetHitSound(optional class<DamageType> DamageType)
{
    // If they are taking damage because they fell, return a falling pain sound
    if (DamageType.Name == 'Fell')
    {
        return default.FallingPainSoundGroup;
    }

    // If they are taking damage because they are burning, return a burning pain sound
    if (DamageType.Name == 'DHBurningDamageType')
    {
        return default.BurningPainSoundGroup;
    }

    // Otherwise, return a wounding pain sound
    return default.WoundingPainSoundGroup;
}

defaultproperties
{
    BurningPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Burning'
}

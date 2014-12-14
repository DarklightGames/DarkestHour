//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PawnSoundGroup extends ROPawnSoundGroup
    abstract;

var() sound         BurningPainSoundGroup;

static function Sound GetHitSound(optional class<DamageType> DamageType)
{
    //If they are taking damage because they fell, return a falling pain sound
    if (DamageType.Name == 'Fell')
        return default.FallingPainSoundGroup;

    if (DamageType.Name == 'DH_BurningDamType')
        return default.BurningPainSoundGroup;

    //Otherwise, return a wounding pain sound
    return default.WoundingPainSoundGroup;
}

defaultproperties
{
    BurningPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Burning'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPawnSoundGroup extends ROPawnSoundGroup
    abstract;

var     sound   BurningPainSoundGroup;
var     sound   GaggingPainSoundGroup; //exposure to WP and other poisonous gases

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

    // If they are taking damage because they are standing in WP gas, return a choking / coughing sound
    if (DamageType.Name == 'DHShellSmokeWPGasDamageType')
    {
        return default.GaggingPainSoundGroup;
    }

    // Otherwise, return a wounding pain sound
    return default.WoundingPainSoundGroup;
}

defaultproperties
{
    BurningPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Burning'
    GaggingPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Gagging'
}

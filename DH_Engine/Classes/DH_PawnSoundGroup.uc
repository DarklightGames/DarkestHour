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

/*static function Sound GetDeathSound(optional int HitIndex)
{
    //Check for a Head shot
    if (HitIndex == 1)
        return default.HeadShotDeathSoundGroup;
    //Check for Upper Torso shot
    else if (HitIndex == 2)
        return default.UpperBodyShotDeathSoundGroup;
    //Check for Lower Torso shot
    else if (HitIndex == 3)
        return default.LowerBodyShotDeathSoundGroup;
    //Check for Arm/Hand and Leg/Foot shot
    else if (HitIndex >= 4 && HitIndex <= 15)
        return default.LimbShotDeathSoundGroup;

    //Hit somewhere without a group, return a generic sound
    return default.GenericDeathSoundGroup;
}*/

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     BurningPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Burning'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPawnSoundGroup extends ROPawnSoundGroup
    abstract;

var     Sound   BurningPainSoundGroup;
var     Sound   GaggingPainSoundGroup;  // Exposure to WP and other poisonous gases.

var     array<Sound>    CustomLandSounds;
var     array<Sound>    CustomJumpSounds;

static function Sound GetSound(ESoundType SoundType, optional int SurfaceID)
{
    local bool bIsCustomSurface;

    bIsCustomSurface = SurfaceID >= arraycount(default.LandSounds);
    SurfaceID = SurfaceID % arraycount(default.LandSounds);

    if( SoundType == EST_Land )
	{
        if (bIsCustomSurface)
        {
            return default.CustomLandSounds[SurfaceID];
        }
        else
        {
		    return default.LandSounds[SurfaceID];
        }
	}
	else if( SoundType == EST_Jump )
	{
        if (bIsCustomSurface)
        {
            return default.CustomJumpSounds[SurfaceID];
        }
        else
        {
	  	    return default.JumpSounds[SurfaceID];
        }
	}
	else
	{
        return default.Sounds[int(SoundType)];
    }
}

static function sound GetHitSound(optional class<DamageType> DamageType)
{
    // If they are taking damage because they fell, return a falling pain sound
    if (DamageType.Name == 'Fell')
    {
        return default.FallingPainSoundGroup;
    }
    else if (DamageType.Name == 'DHBurningDamageType')
    {
        // If they are taking damage because they are burning, return a burning pain sound
        return default.BurningPainSoundGroup;
    }
    else if (DamageType.Name == 'DHShellSmokeWPGasDamageType')
    {
        // If they are taking damage because they are standing in WP gas, return a choking / coughing sound
        return default.GaggingPainSoundGroup;
    }

    // Otherwise, return a wounding pain sound
    return default.WoundingPainSoundGroup;
}

defaultproperties
{
    BurningPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Burning'
    GaggingPainSoundGroup=SoundGroup'DH_Inf_Player.playerhurt.Gagging'

    CustomLandSounds(0)=Sound'Inf_Player.LandDirt'      // EST_Custom00 (No Effects)
    CustomLandSounds(1)=Sound'Inf_Player.LandDirt'      // EST_Custom01 (Sand)
    CustomLandSounds(2)=Sound'Inf_Player.LandDirt'      // EST_Custom02 (Sandbags)
    CustomLandSounds(3)=Sound'Inf_Player.LandAsphalt'   // EST_Custom03 (Brick)
    CustomLandSounds(4)=Sound'Inf_Player.LandGrass'     // EST_Custom04 (Hedgerow)

    CustomJumpSounds(0)=Sound'Inf_Player.JumpDirt'      // EST_Custom00 (No Effects)
    CustomJumpSounds(1)=Sound'Inf_Player.JumpDirt'      // EST_Custom01 (Sand)
    CustomJumpSounds(2)=Sound'Inf_Player.JumpDirt'      // EST_Custom02 (Sandbags)
    CustomJumpSounds(3)=Sound'Inf_Player.JumpAsphalt'   // EST_Custom03 (Brick)
    CustomJumpSounds(4)=Sound'Inf_Player.JumpGrass'     // EST_Custom04 (Hedgerow)
}

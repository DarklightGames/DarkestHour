//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSmokeEffectBase extends Emitter
    abstract;

// Modified to destroy effect so if reset (if the ResetGame option is used or a new round starts on the same map)
// Note this requires special handling to call this on a net client, as Reset() is normally only called on authority roles
simulated function Reset()
{
    Destroy();
}

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    LifeSpan=65.0
    Style=STY_Masked
    bHardAttach=true
}

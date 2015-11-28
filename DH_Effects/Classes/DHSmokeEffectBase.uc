//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSmokeEffectBase extends Emitter
    abstract;

// Modified so in single player this effect is removed if the ResetGame option is used (note this won't work on a net client as Reset is only called on the server)
simulated function Reset()
{
    Destroy();
}

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    bNetTemporary=true
    RemoteRole=ROLE_SimulatedProxy
    LifeSpan=65.0
    Style=STY_Masked
    bHardAttach=true
    bDirectional=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMortarExplosion extends Emitter;

var bool bUseFlash;

// Parent class for all mortar explosions - add flash of light upon impact
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && bUseFlash)
    {
        bDynamicLight = true;
        SetTimer(0.15, false);
    }

    Super.PostBeginPlay();
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true

    bUseFlash=true

    bDynamicLight=false

    LightEffect=LE_NonIncidence
    LightType=LT_Steady
    LightBrightness = 128.0 //64
    LightRadius = 24.0 //16
    LightHue = 20
    LightSaturation = 28
    AmbientGlow = 254
    LightCone = 8
}

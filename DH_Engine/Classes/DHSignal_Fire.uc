//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSignal_Fire extends DHSignal
    abstract;

defaultproperties
{
    SignalName="Fire"
    MenuIconMaterial=Texture'DH_InterfaceArt2_tex.fire'
    WorldIconMaterial=TexOscillator'DH_InterfaceArt2_tex.fire_pulse'
    MyColor=(R=178,G=34,B=34,A=255)
    bIsUnique=true
}

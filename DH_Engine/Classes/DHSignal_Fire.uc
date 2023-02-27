//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSignal_Fire extends DHSignal
    abstract;

defaultproperties
{
    SignalName="Fire"
    MenuIconMaterial=Texture'DH_InterfaceArt2_tex.Icons.fire'
    WorldIconMaterial=TexOscillator'DH_InterfaceArt2_tex.Icons.fire_pulse'
    MyColor=(R=178,G=34,B=34,A=255)
    bIsUnique=true
}

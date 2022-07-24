//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHSquadSignal_Move extends DHSquadSignal
    abstract;

defaultproperties
{
    SignalName="Move"
    MenuIconMaterial=Texture'DH_InterfaceArt2_tex.Icons.move'
    WorldIconMaterial=TexOscillator'DH_InterfaceArt2_tex.Icons.move_pulse'
    Color=(R=186,G=85,B=211,A=255)
    bIsUnique=true
}

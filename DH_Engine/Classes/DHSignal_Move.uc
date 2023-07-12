//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSignal_Move extends DHSignal
    abstract;

defaultproperties
{
    SignalName="Move"
    MenuIconMaterial=Texture'DH_InterfaceArt2_tex.Icons.move'
    WorldIconMaterial=TexOscillator'DH_InterfaceArt2_tex.Icons.move_pulse'
    MyColor=(R=186,G=85,B=211,A=255)
    bIsUnique=true
    bSquadMembersOnly=true
}

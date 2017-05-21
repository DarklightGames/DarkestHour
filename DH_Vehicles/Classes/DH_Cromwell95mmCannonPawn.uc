//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Cromwell95mmCannonPawn extends DH_CromwellCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Cromwell95mmCannon'
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.Cromwell95mm_sight'
    CannonScopeCenter=none // no need for a separate 2nd sight overlay as there's no moving part, & the center is incorporated in the GunsightOverlay
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'
}

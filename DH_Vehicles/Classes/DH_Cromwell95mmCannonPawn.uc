//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cromwell95mmCannonPawn extends DH_CromwellCannonPawn;

defaultproperties
{
    GunClass=Class'DH_Cromwell95mmCannon'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Cromwell95mm_sight' // No.48 x3 L Mk I sight
    CannonScopeCenter=none // no need for a separate 2nd sight overlay as there's no moving part, & the center is incorporated in the GunsightOverlay
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.JagdTiger_shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.JagdTiger_shell_reload'
}

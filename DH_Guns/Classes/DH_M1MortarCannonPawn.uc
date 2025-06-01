//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
class DH_M1MortarCannonPawn extends DH_Model35MortarCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_M1MortarCannon'

    AmmoShellTextures(0)=Texture'DH_Model35Mortar_tex.interface.US_HE_M43A1_ICON'
    AmmoShellTextures(1)=Texture'DH_Model35Mortar_tex.interface.US_WP_M56_ICON'
    AmmoShellTextures(2)=Texture'DH_Model35Mortar_tex.interface.US_HE_M56_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_Model35Mortar_tex.interface.US_HE_M43A1_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_Model35Mortar_tex.interface.US_WP_M56_ICON_RELOAD'
    AmmoShellReloadTextures(2)=Texture'DH_Model35Mortar_tex.interface.US_HE_M56_ICON_RELOAD'

    PlayerCameraBone="US_CAMERA_COM"
    CameraBone="US_GUNSIGHT_CAMERA"

    ArtillerySpottingScopeClass=class'DH_Guns.DH_Model35MortarArtillerySpottingScope'
}

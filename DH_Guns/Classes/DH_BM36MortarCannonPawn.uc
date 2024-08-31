//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BM36MortarCannonPawn extends DH_Model35MortarCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_BM36MortarCannon'

    AmmoShellTextures(0)=Texture'DH_Model35Mortar_tex.interface.RU_HE_57O832_ICON'
    AmmoShellTextures(1)=Texture'DH_Model35Mortar_tex.interface.RU_SMOKE_57D832_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_Model35Mortar_tex.interface.RU_HE_57O832_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_Model35Mortar_tex.interface.RU_SMOKE_57D832_ICON_RELOAD'

    PlayerCameraBone="RU_CAMERA_COM"
    CameraBone="RU_GUNSIGHT_CAMERA"

    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_Model35Mortar'

    // Spotting Scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.bm36mortar_tube_ext')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.bm36mortar_tube_ext')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.bm36mortar_tube_ext')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.bm36mortar_tube_ext')
}

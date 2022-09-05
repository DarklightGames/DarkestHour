//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Bren_VehHUDOverlay extends VehicleHUDOverlay;

var name BipodBone;

// Modified to hide the bipod on the weapon mesh.
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetBoneScale(0, 0.0, BipodBone);

    // HACK: fixes the bug where the gun is in the wrong animation to start with
    LoopAnim('deploy_idle');
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_ZB_1st.BrenMk2_1st'
    Skins(0)=Texture'DH_Bren_tex.one.Bren_D'
    Skins(1)=Texture'Weapons1st_tex.Arms.hands'
    Skins(2)=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    bUseHighDetailOverlayIndex=false
    BipodBone="bipod_base"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T_4GEarlyTank extends DH_PanzerIVGEarlyTank;

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(Class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T-IV mod.G"
    ReinforcementCost=4
    VehicleTeam=1

    // Hull mesh
    Mesh=SkeletalMesh'axis_Panzer4F2_anm.Panzer4F2_body_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.sov_PanzerIV_ext'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.sov_PanzerIV_ext'
}

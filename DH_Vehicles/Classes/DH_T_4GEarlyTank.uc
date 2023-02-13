//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T_4GEarlyTank extends DH_PanzerIVGEarlyTank;

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
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
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
}

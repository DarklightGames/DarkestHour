//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PanzerIVF1Tank_CamoTwo extends DH_PanzerIVF1Tank;

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
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2'
    Skins(1)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2'
}

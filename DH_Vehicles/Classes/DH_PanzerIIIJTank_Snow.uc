//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIIJTank_Snow extends DH_PanzerIIIJTank;

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
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.Panzer3J_ext_winter'
    Skins(2)=Texture'GUP_vehicles_tex.WELT_Panzer4F2_treadsnow'
    Skins(3)=Texture'GUP_vehicles_tex.WELT_Panzer4F2_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.Panzer3J_ext_winter'
    //DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex5.Destroyed.WELT_panzer3_body_winter_dest'
}

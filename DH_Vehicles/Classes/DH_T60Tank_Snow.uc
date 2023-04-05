//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T60Tank_Snow extends DH_T60Tank;

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
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.T60_ext_snow'
    Skins(1)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.Treads.SU76_Treadsnow'  //not entirely "correct" but it looks ok
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.T60_ext_snow'

}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T_5GTank extends DH_PantherGTank;

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
    VehicleNameString="T-V 'Pantera' mod.G"
    VehicleTeam=1

    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_allied_ext' // allied capture panther, should be usable to both red army and western allies because both seemed to use similar white stars
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_allied_ext'
}

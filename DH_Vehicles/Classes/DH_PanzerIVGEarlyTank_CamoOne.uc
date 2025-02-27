//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIVGEarlyTank_CamoOne extends DH_PanzerIVGEarlyTank;

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
    Skins(0)=Texture'axis_vehicles_tex2.ext_vehicles.panzer4_stripe_ext'
    Skins(1)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    CannonSkins(0)=Texture'axis_vehicles_tex2.ext_vehicles.panzer4_stripe_ext'
}

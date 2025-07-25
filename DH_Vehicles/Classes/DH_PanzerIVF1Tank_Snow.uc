//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIVF1Tank_Snow extends DH_PanzerIVF1Tank;

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
    Skins(0)=Texture'GUP_vehicles_tex.WELT_Panzer4F1_ext'
    Skins(1)=Texture'axis_vehicles_tex.Panzer4F2_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Panzer4F2_treadsnow'
    CannonSkins(0)=Texture'GUP_vehicles_tex.WELT_Panzer4F1_ext'
}

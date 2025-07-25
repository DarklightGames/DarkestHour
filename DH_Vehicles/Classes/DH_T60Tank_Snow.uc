//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T60Tank_Snow extends DH_T60Tank;

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
    Skins(0)=Texture'DH_VehiclesSOV_tex.T60_ext_snow'
    Skins(1)=Texture'allies_vehicles_tex.SU76_Treadsnow'
    Skins(2)=Texture'allies_vehicles_tex.SU76_Treadsnow'  //not entirely "correct" but it looks ok
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.T60_ext_snow'

}

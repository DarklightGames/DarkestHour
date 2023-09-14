//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WirbelwindTank_Snow extends DH_WirbelwindTank;

defaultproperties
{
    bIsWinterVariant=true
    VehicleNameString="Flakpanzer IV 'Wirbelwind'"
    Skins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.Panzer4F2_ext_winter'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    CannonSkins(1)=Texture'DH_Artillery_tex.Flak38.wirbelwind_turret_snow'

    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex8.Destroyed.Panzer4F2_ext_Winter_dest'
    DestroyedMeshSkins(2)=Combiner'DH_Artillery_tex.Flak38.Wirbelwind_turret_snow_dest'
}


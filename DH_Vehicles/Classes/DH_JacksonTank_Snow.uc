//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonTank_Snow extends DH_JacksonTank;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext'
    Skins(4)=Texture'DH_VehiclesUS_tex2.Treads.M10_treadsnow'
    Skins(5)=Texture'DH_VehiclesUS_tex2.Treads.M10_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesUS_tex5.Destroyed.M36_Bodysnow_ext_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesUS_tex5.Destroyed.M36_turretsnow_ext_dest'
    DestroyedMeshSkins(5)=Combiner'DH_VehiclesUS_tex5.Destroyed.M36_turretsnow_ext_dest'
}

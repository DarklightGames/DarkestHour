//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3476Tank_German extends DH_T3476Tank;

defaultproperties
{
    VehicleNameString="Panzer T-34"
    VehicleTeam=0
    Skins(0)=Texture'BDJ_vehicles_tex.Vehicle_ext.T3476_ext_camo'       // note texture package is distributed with RO, as its vehicles are included in ROCustom.u code package
    CannonSkins(0)=Texture'BDJ_vehicles_tex.Vehicle_ext.T3476_ext_camo' // it is a captured T34 with German markings (the camo name is misleading)
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex8.Destroyed.T3476_ext_German_dest'
}

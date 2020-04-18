//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_T_VI_Tank extends DH_PantherGTank;

defaultproperties
{
    VehicleNameString="T-VI 'Panther' mod. G"
    VehicleTeam=1

    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_allied_ext' // allied capture panther, should be usable to both red army and western allies because both seemed to use similar white stars
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_allied_ext'
    //DestroyedMeshSkins(0)=
    //to do: destroyed mesh skin (although its just white stars?)
}

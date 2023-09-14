//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A276W_Berlin extends DH_ShermanTank_M4A276W_Soviet;

defaultproperties
{
    CannonSkins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext_berlin'
    CannonSkins(1)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext_berlin'
	//problem: cannon mask uses default texture so has no stripes on it even though that special texture has stripes on the mask
}

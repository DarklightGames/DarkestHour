//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ShermanTank_M4A275W_Soviet extends DH_ShermanTank_M4A375W; 

defaultproperties
{
    VehicleNameString="M4A2(75)W"

    // Hull mesh

    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A2_soviet'
	
    // Movement
	//different diesel engine
    MaxCriticalSpeed=777.0 // 45 kph
    GearRatios(1)=0.19
    GearRatios(3)=0.62
    GearRatios(4)=0.76
    TransRatio=0.094
	
	//to do: destroyed textures
}


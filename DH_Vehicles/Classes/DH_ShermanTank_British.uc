//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_British extends DH_ShermanTank;

defaultproperties
{
    VehicleNameString="Sherman Mk.II"
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext'
    CannonSkins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Brit_Sherman_Dest'
    NewVehHitpoints(0)=(PointRadius=2.0,PointBone="turret",PointOffset=(X=58.00,Y=26.50,Z=9.00),NewHitPointType=NHP_GunOptics)
}

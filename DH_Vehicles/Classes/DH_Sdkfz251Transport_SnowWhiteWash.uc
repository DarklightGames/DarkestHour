//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz251Transport_SnowWhiteWash extends DH_Sdkfz251Transport;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Halftrack_body_snow3'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex.Destroyed.halftrack_stripe_dest' // close enough match that you can't see the difference in destroyed, burning vehicle
}

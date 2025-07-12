//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz251Transport_SnowTwo extends DH_Sdkfz251Transport; // snow topped version of camo pattern very similar to CamoFour

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.Halftrack_body_snow2'
    Skins(1)=Texture'axis_vehicles_tex.Halftrack_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Halftrack_treadsnow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex.halftrack_stripe_dest' // close enough match that you can't see the difference in destroyed, burning vehicle
}

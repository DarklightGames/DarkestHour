//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Spitfire_Airplane extends DHAirplane;

defaultproperties
{
    AirplaneName="Supermarine Spitfire"
    Mesh=Mesh'DH_Airplanes_anm.Spitfire'
    CannonInfos(0)=(CannonClass=class'DH_HS404Cannon',CannonBone="cannon.001")
    CannonInfos(1)=(CannonClass=class'DH_HS404Cannon',CannonBone="cannon.002")
}


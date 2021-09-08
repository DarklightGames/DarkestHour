//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BF109_Airplane extends DHAirplane;

defaultproperties
{
    AirplaneName="Messerschmidt Bf 109"
    Mesh=Mesh'DH_Airplanes_anm.bf109g'

    BombBoneNames(0)="bomb.001" // left wing
    BombBoneNames(1)="bomb.002" // undercarriage
    BombBoneNames(2)="bomb.003" // right wing
}

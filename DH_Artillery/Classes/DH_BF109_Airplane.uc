//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BF109_Airplane extends DHAirplane;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

}

defaultproperties
{
    //AirplaneName="Messerschmidt Bf 109"
    Mesh=Mesh'DH_Airplanes_anm.bf109g'
    MaxSpeed = 600
    //BombBoneNames(0)="bomb.001" // left wing
    //BombBoneNames(1)="bomb.002" // undercarriage
    //BombBoneNames(2)="bomb.003" // right wing
}

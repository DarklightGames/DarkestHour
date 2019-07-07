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
    MaxBankAngle = 65
    BankRate = 0.65
}

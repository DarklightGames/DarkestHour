//==============================================================================
// DH_GreyhoundArmoredCar_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M8 'Greyhound' Armored Car - winter variant
//==============================================================================
class DH_GreyhoundArmoredCarFixed_Snow extends DH_GreyhoundArmoredCar_Snow;

var()	InterpCurve		Def_TorqueCurve, Mud_TorqueCurve, Snow_TorqueCurve;

simulated function Tick(float DeltaTime)
{
    local ESurfaceTypes ST;
	local vector HitLoc, HitNorm;
	local Material HitMat;

	Super.Tick( DeltaTime );

	Trace(HitLoc, HitNorm, Location + vect(0, 0, -512), Location + vect(0,0,64), false,, HitMat);

	if (HitMat == None)
		ST = EST_Default;
	else
		ST = ESurfaceTypes(HitMat.SurfaceType);

	Level.Game.Broadcast(self, "Current SurfaceType: "$ST, 'Say');


	switch( ST )
	{
		case EST_Default:
            //Throttle = 1.0;
            //TorqueCurve = Def_TorqueCurve;
			break;

		case EST_Dirt:

			break;

		case EST_Mud:
		    Throttle = FClamp( Throttle, -0.20, 0.20);
            //TorqueCurve = Mud_TorqueCurve;
			break;

		case EST_Snow:
	        Throttle = FClamp( Throttle, -0.50, 0.50);
            //TorqueCurve = Snow_TorqueCurve;
			break;
	}





/*
Start = Location - Vect(0,0,1)*CollisionHeight;
		End = Start - Vect(0,0,16);
		A = Trace(hl,hn,End,Start,false,,FloorMat);
		if (FloorMat !=None)
			SurfaceTypeID = FloorMat.SurfaceType;
*/


}


defaultproperties
{
    Def_TorqueCurve=(Points=((OutVal=2.000000),(InVal=400.000000,OutVal=2.750000),(InVal=3500.000000,OutVal=5.000000),(InVal=4600.000000)))
    Mud_TorqueCurve=(Points=((OutVal=1.000000),(InVal=200.000000,OutVal=0.750000),(InVal=1500.000000,OutVal=2.000000),(InVal=2200.000000)))
    Snow_TorqueCurve=(Points=((OutVal=1.500000),(InVal=300.000000,OutVal=1.500000),(InVal=2000.000000,OutVal=3.000000),(InVal=3200.000000)))
	PassengerWeapons(0)=(WeaponPawnClass=Class'DH_GreyhoundFixed.DH_GreyhoundCannonFixedPawn_Snow')
}


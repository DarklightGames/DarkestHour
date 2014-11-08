//==============================================================================
// DH_StuH42CannonShellSmoke
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German 105mm howitzer smoke shell (10-cm F.H.Gr.Nb.)
//==============================================================================
class DH_StuH42CannonShellSmoke extends DH_Stug3GCannonShellSmoke;


defaultproperties
{
	SmokeEffectClass=class'DH_Effects.DH_SmokeShellEffect_Large'
	ShellDiameter=105.0
	ImpactDamage=175 // 75mm smoke shells are 125, so increased as this is a larger, heavier shell
	BallisticCoefficient=2.96 // same as 105mm HE or HEAT shells
	Speed=29874.0 // same as 105mm HE or HEAT shells
	MaxSpeed=29874.0
	Tag="10cm F.H.Gr.Nb."
}

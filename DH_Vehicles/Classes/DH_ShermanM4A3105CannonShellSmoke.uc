//==============================================================================
// DH_ShermanM4A3105CannonShellSmoke
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American 105mm howitzer M60 WP smoke shell
//==============================================================================
class DH_ShermanM4A3105CannonShellSmoke extends DH_ShermanCannonShellSmoke;


defaultproperties
{
	SmokeEffectClass=class'DH_Effects.DH_SmokeShellEffect_Large'
	ShellDiameter=10.5
	ImpactDamage=175 // 75mm smoke shells are 125, so increased as this is a larger, heavier shell
	BallisticCoefficient=2.96 // same as 105mm HE or HEAT shells
	Speed=28486.0 // same as 105mm HE shell
	MaxSpeed=28486.0
	Tag="M60 WP"
}

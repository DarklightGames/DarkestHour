//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_YellowGreenTankShellTracer extends Effects;


//  More realistic shell tracer, harder to see
// (commander by binoculars can see it better than gunner, as in real life)

auto state Start
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMin(DrawScale + dt*0.3, 0.20));
        if (DrawScale >= 0.20)
        {
            SetDrawScale(0.20);
            GotoState('');
        }
    }
}

defaultproperties
{
    bTrailerSameRotation=true
    Physics=PHYS_Trailer
    Texture=Texture'Effects_Tex.Weapons.Russ_Flare_Final'
    DrawScale=0.010000
    Skins(0)=Texture'Effects_Tex.Weapons.Russ_Flare_Final'
    Style=STY_Additive
    Mass=13.000000
}

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
        SetDrawScale(FMin(DrawScale + dt*0.3, 0.2));
        if (DrawScale >= 0.2)
        {
            SetDrawScale(0.2);
            GotoState('');
        }
    }
}

defaultproperties
{
    bTrailerSameRotation=true
    Physics=PHYS_Trailer
    Texture=texture'Effects_Tex.Weapons.Russ_Flare_Final'
    DrawScale=0.01
    Skins(0)=texture'Effects_Tex.Weapons.Russ_Flare_Final'
    Style=STY_Additive
    Mass=13.0
}

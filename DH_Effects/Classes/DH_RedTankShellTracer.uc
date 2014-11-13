//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RedTankShellTracer extends Effects;



auto state Start
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMin(DrawScale + dt*0.3, 0.3));
        if (DrawScale >= 0.3)
        {
            SetDrawScale(0.3);
            GotoState('');
        }
    }
}

defaultproperties
{
     bTrailerSameRotation=true
     Physics=PHYS_Trailer
     Texture=Texture'DH_FX_Tex.Effects.RedFlare'
     DrawScale=0.010000
     Skins(0)=Texture'DH_FX_Tex.Effects.RedFlare'
     Style=STY_Additive
     Mass=13.000000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellEject extends ROShellEject
	abstract;

// Casing smoke variables
var     class<Emitter>  CasingTrailClass;     // bullet casing "smoke" emitter effect
var     Emitter         CasingTrail;
var     bool            bHasCasingTrail;

simulated function Destroyed()
{
    Super.Destroyed();

    if (CasingTrail != none)
    {
        CasingTrail.Destroy();
    }
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
    
    //RandSpin(100000);
    
    if (Level.NetMode != NM_DedicatedServer && bHasCasingTrail)
    {
        CasingTrail = Spawn(CasingTrailClass, self);
        CasingTrail.SetBase(self);
    }
}

defaultproperties
{       
    CasingTrailClass=class'DH_Effects.DHCasingTrail'	
    bHasCasingTrail=true
    bFixedRotationDir=true
    bRotateToDesired=false
}

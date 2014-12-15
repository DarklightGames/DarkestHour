//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ClientBullet extends DH_Bullet // Matt: originally extended ROClientBullet
    abstract;

// Matt: this is the function from the original parent ROClientBullet, with a couple of things added from DH_Bullet
simulated function PostBeginPlay()
{
    local Vector HitNormal;
    local Actor  TraceHitActor;

    if (bDebugROBallistics) // from DH_Bullet
    {
        bDebugBallistics = true;
    }

    Acceleration = vect(0.0,0.0,0.0); // new in this class, not sure what it does, maybe something native
    Velocity = vector(Rotation) * Speed;
    BCInverse = 1.0 / BallisticCoefficient;

    if (bDebugBallistics && ROPawn(Instigator) != none) // ROPawn added in this class
    {
        FlightTime = 0.0;
//      OrigLoc = Location; // set below, regardless of whether debugging

        TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), Location + (Instigator.CollisionRadius + 5.0) * vector(Rotation), true);
        Log("Debug tracing: TraceHitActor=" @ TraceHitActor);

        if (TraceHitActor.IsA('ROBulletWhipAttachment'))
        {
            TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), TraceHitLoc + 5.0 * vector(Rotation), true);
        }

        // super slow debugging (added back in this class - was commented out in ROBallisticProjectile)
        Spawn(class'DH_DebugTracerGreen', self, , TraceHitLoc, Rotation);
    }

    OrigLoc = Location; // from DH_Bullet, as seems necessary for WhizType handling, but wasn't originally being inherited
}

defaultproperties
{
    ImpactEffect=class'DH_Effects.DH_BulletHitEffect'
    WhizSoundEffect=class'DH_Effects.DH_BulletWhiz'
}

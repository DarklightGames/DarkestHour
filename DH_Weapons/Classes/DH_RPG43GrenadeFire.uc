//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeFire extends DHThrownExplosiveFire;

//Overriden to remove use of fuze times
event ModeTick(float dt)
{
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int projectileID;
    local int SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X * ProjSpawnOffset.X;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != none)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    CalcSpreadModifiers();

    AppliedSpread = Spread;

    switch (SpreadStyle)
    {
        case SS_Random:
            X = vector(Aim);
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                R.Yaw = AppliedSpread * ((FRand()-0.5)/1.5);
                R.Pitch = AppliedSpread * (FRand()-0.5);
                R.Roll = AppliedSpread * (FRand()-0.5);
                SpawnProjectile(StartProj, rotator(X >> R));
            }
            break;

        case SS_Line:
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                theta = AppliedSpread*PI/32768*(projectileID - float(SpawnCount-1)/2.0);
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, rotator(X >> Aim));
            }
            break;

        default:
            SpawnProjectile(StartProj, Aim);
    }
}

defaultproperties
{
    bSplashDamage=false
    bRecommendSplashDamage=false
    MaxHoldTime=60.0000 //Why hold a grenade for more than a minute?
    AmmoClass=class'DH_Weapons.DH_RPG43GrenadeAmmo'
    ProjectileClass=class'DH_Weapons.DH_RPG43GrenadeProjectile'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeFire extends DHThrownExplosiveFire;

// Modified to remove use of fuze times
event ModeTick(float DeltaTime)
{
}

function DoFireEffect()
{
    local Actor   Other;
    local vector  StartProj, StartTrace, HitLocation, HitNormal, X, Y, Z;
    local rotator R, Aim;
    local float   Theta;
    local int     ProjectileID, SpawnCount;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + (X * ProjSpawnOffset.X);

    // Check if projectile would spawn through a wall & adjust start location accordingly
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

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                R.Yaw = AppliedSpread * ((FRand() - 0.5) / 1.5);
                R.Pitch = AppliedSpread * (FRand() - 0.5);
                R.Roll = AppliedSpread * (FRand() - 0.5);
                SpawnProjectile(StartProj, rotator(X >> R));
            }

            break;

        case SS_Line:
            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                Theta = AppliedSpread * PI / 32768 * (ProjectileID - float(SpawnCount - 1) / 2.0);
                X.X = Cos(Theta);
                X.Y = Sin(Theta);
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
    MaxHoldTime=60.0 // why hold a grenade for more than a minute?
    AmmoClass=class'DH_Weapons.DH_RPG43GrenadeAmmo'
    ProjectileClass=class'DH_Weapons.DH_RPG43GrenadeProjectile'
}

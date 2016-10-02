//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1SmokeGrenadeTossFire extends DH_M1GrenadeTossFire;

event ModeTick(float DeltaTime)
{
    local ROExplosiveWeapon Exp;

    if (Weapon.Role == ROLE_Authority)
    {
        Exp = ROExplosiveWeapon(Weapon);

        if (Exp.bPrimed && HoldTime > 0.0)
        {
            if (Exp.CurrentFuzeTime > (AddedFuseTime * -1.0))
            {
                Exp.CurrentFuzeTime -= DeltaTime;
            }
            else if (!Exp.bAlreadyExploded)
            {
                Exp.bAlreadyExploded = true;
            }
        }
    }
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
    MaxHoldTime=4.95
    AmmoClass=class'ROAmmo.RDG1GrenadeAmmo'
    ProjectileClass=class'DH_Equipment.DH_RDG1SmokeGrenadeProjectile'
}

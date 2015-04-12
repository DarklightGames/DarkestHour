//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGrenadeFire extends ROThrownExplosiveFire;

var bool bIsSmokeGrenade;

event ModeTick(float dt)
{
    local ROExplosiveWeapon Exp;

    if (Weapon.Role == ROLE_Authority)
    {
        Exp = ROExplosiveWeapon(Weapon);

        if (Exp.bPrimed && HoldTime > 0.0)
        {
            if (Exp.CurrentFuzeTime  > (AddedFuseTime * -1.0))
            {
                Exp.CurrentFuzeTime -= dt;
            }
            else if (!Exp.bAlreadyExploded)
            {
                Exp.bAlreadyExploded = true;

                if (!bIsSmokeGrenade)
                {
                    // WeaponTODO: Find a better way to prevent throwing an extra nade when a nade blows up in your hand than just using up all nade ammo
                    Weapon.ConsumeAmmo(ThisModeNum, Weapon.AmmoAmount(ThisModeNum));
                    DoFireEffect();
                    HoldTime = 0.0;
                }
            }
        }
    }
}

function DoFireEffect()
{
    local vector  StartProj, StartTrace, X, Y, Z, HitLocation, HitNormal;
    local rotator R, Aim;
    local Actor   Other;
    local int     ProjectileID, SpawnCount;
    local float   Theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + (X * ProjSpawnOffset.X);

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != none)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * Int(Load));

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
                Theta = AppliedSpread * PI / 32768.0 * (ProjectileID - Float(SpawnCount - 1) / 2.0);
                X.X = Cos(Theta);
                X.Y = Sin(Theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, rotator(X >> Aim));
            }

            break;

        default:

            SpawnProjectile(StartProj, Aim);
    }

    if (!bIsSmokeGrenade)
    {
        // Nade blew up in hand, kill the holder if they aren't already
        if (ROExplosiveWeapon(Weapon).bAlreadyExploded && ROPawn(Weapon.Instigator) != none)
        {
            ROPawn(Weapon.Instigator).KilledSelf(ProjectileClass.default.MyDamageType);
        }
    }
}

defaultproperties
{
    AddedFuseTime=0.38
    bPullAnimCompensation=true
    ProjSpawnOffset=(X=25.0,Y=0.0,Z=0.0)
    bUsePreLaunchTrace=false
    bWaitForRelease=true
    PreFireAnim="Pre_Fire"
    FireAnim="Throw"
    TweenTime=0.01
    FireForce="RocketLauncherFire"
    FireRate=50.0
    BotRefireRate=0.5
    WarnTargetPct=0.9
    AimError=200.0
    Spread=75.0
    SpreadStyle=SS_Random
}

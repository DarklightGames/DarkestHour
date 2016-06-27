//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDFire extends ROBoltFire;

simulated function EjectShell()
{
    local coords EjectCoords;
    local vector EjectOffset;
    local vector X,Y,Z;
    local rotator EjectRot;
    local ROShellEject Shell;

    if (Instigator.bBipodDeployed)
    {
        if (ShellEjectClass != None)
        {
            Weapon.GetViewAxes(X,Y,Z);

            EjectOffset = Instigator.Location + Instigator.EyePosition();
            EjectOffset = EjectOffset + X * ShellIronSightOffset.X + Y * ShellIronSightOffset.Y +  Z * ShellIronSightOffset.Z;

            EjectRot = Rotator(Y);
            EjectRot.Yaw += 16384;
            Shell=Weapon.Spawn(ShellEjectClass,none,,EjectOffset,EjectRot);
            EjectRot = Rotator(Y);
            EjectRot += ShellRotOffsetIron;

            EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
            EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
            EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

            Shell.Velocity = (Shell.MinStartSpeed + FRand() * (Shell.MaxStartSpeed-Shell.MinStartSpeed)) * vector(EjectRot);
        }
    }
    else
    {
        if (ShellEjectClass != None)
        {
            EjectCoords = Weapon.GetBoneCoords(ShellEmitBone);

            // Find the shell eject location then scale it down 5x (since the weapons are scaled up 5x)
            EjectOffset = EjectCoords.Origin - Weapon.Location;
            EjectOffset = EjectOffset * 0.2;
            EjectOffset = Weapon.Location + EjectOffset;

            EjectOffset = EjectOffset + EjectCoords.XAxis * ShellHipOffset.X + EjectCoords.YAxis * ShellHipOffset.Y +  EjectCoords.ZAxis * ShellHipOffset.Z;

            EjectRot = Rotator(-EjectCoords.YAxis);
            Shell=Weapon.Spawn(ShellEjectClass,none,,EjectOffset,EjectRot);
            EjectRot = Rotator(EjectCoords.XAxis);
            EjectRot += ShellRotOffsetHip;

            EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
            EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
            EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

            Shell.Velocity = (Shell.MinStartSpeed + FRand() * (Shell.MaxStartSpeed-Shell.MinStartSpeed)) * vector(EjectRot);
        }
    }
}

defaultproperties
{
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-225.000000,Y=-15.000000,Z=-15.000000)
    bUsePreLaunchTrace=False
    FireIronAnim="shoot"
    FireSounds(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    maxVerticalRecoilAngle=750
    maxHorizontalRecoilAngle=650
    ShellEjectClass=class'ROAmmo.ShellEject1st14mm'
    ShellIronSightOffset=(X=10.000000,Y=3.000000)
    ShellRotOffsetIron=(Pitch=-10000)
    bAnimNotifiedShellEjects=False
    bWaitForRelease=True
    FireAnim="shoot"
    TweenTime=0.000000
    FireForce="RocketLauncherFire"
    FireRate=2.400000
    AmmoClass=class'ROAmmo.PTRDAmmo'
    ShakeRotMag=(X=100.000000,Y=100.000000,Z=800.000000)
    ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    ShakeRotTime=7.000000
    ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=4.000000
    ProjectileClass=class'DH_Weapons.DH_PTRDBullet'
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPTRD'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=800.000000
    Spread=75.000000
    SpreadStyle=SS_Random
}

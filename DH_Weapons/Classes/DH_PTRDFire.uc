//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDFire extends DHBoltFire;

// Modified to check if Instigator has the bipod deployed instead of checking if he is using ironsights
simulated function EjectShell()
{
    local ROShellEject Shell;
    local coords       EjectCoords;
    local vector       EjectOffset, X, Y, Z;
    local rotator      EjectRot;

    if (Instigator != none && Instigator.bBipodDeployed)
    {
        if (ShellEjectClass != none)
        {
            Weapon.GetViewAxes(X, Y, Z);

            EjectOffset = Instigator.Location + Instigator.EyePosition();
            EjectOffset = EjectOffset + (X * ShellIronSightOffset.X) + (Y * ShellIronSightOffset.Y) +  (Z * ShellIronSightOffset.Z);

            EjectRot = rotator(Y);
            EjectRot.Yaw += 16384;

            Shell = Weapon.Spawn(ShellEjectClass, none,, EjectOffset, EjectRot);

            EjectRot = rotator(Y);
            EjectRot += ShellRotOffsetIron;

            EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
            EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
            EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

            Shell.Velocity = (Shell.MinStartSpeed + (FRand() * (Shell.MaxStartSpeed - Shell.MinStartSpeed))) * vector(EjectRot);
        }
    }
    else
    {
        if (ShellEjectClass != none)
        {
            EjectCoords = Weapon.GetBoneCoords(ShellEmitBone);

            // Find the shell eject location then scale it down 5x (since the weapons are scaled up 5x)
            EjectOffset = EjectCoords.Origin - Weapon.Location;
            EjectOffset = EjectOffset * 0.2;
            EjectOffset = Weapon.Location + EjectOffset;

            EjectOffset = EjectOffset + (EjectCoords.XAxis * ShellHipOffset.X) + (EjectCoords.YAxis * ShellHipOffset.Y) +  (EjectCoords.ZAxis * ShellHipOffset.Z);
            EjectRot = rotator(-EjectCoords.YAxis);

            Shell = Weapon.Spawn(ShellEjectClass, none,, EjectOffset, EjectRot);

            EjectRot = rotator(EjectCoords.XAxis);
            EjectRot += ShellRotOffsetHip;
            EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
            EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
            EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

            Shell.Velocity = (Shell.MinStartSpeed + (FRand() * (Shell.MaxStartSpeed - Shell.MinStartSpeed))) * vector(EjectRot);
        }
    }
}

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-225.0,Y=-15.0,Z=-15.0)
    bUsePreLaunchTrace=false
    FireIronAnim="shoot"
    FireSounds(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    MaxVerticalRecoilAngle=750
    MaxHorizontalRecoilAngle=650
    ShellEjectClass=class'ROAmmo.ShellEject1st14mm'
    ShellIronSightOffset=(X=10.0,Y=3.0)
    ShellRotOffsetIron=(Pitch=-10000)
    bAnimNotifiedShellEjects=false
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.4
    AmmoClass=class'ROAmmo.PTRDAmmo'
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ProjectileClass=class'DH_Weapons.DH_PTRDBullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPTRD'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=800.0
    Spread=75.0
    SpreadStyle=SS_Random
}

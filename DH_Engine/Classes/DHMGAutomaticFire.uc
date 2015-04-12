//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMGAutomaticFire extends DHFastAutoFire
    abstract;

var()       float           PctHipMGPenalty;    // The amount of recoil to add when the player firing an MG from the hip
var         DHMGWeapon       MGWeapon;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    MGWeapon = DHMGWeapon(Weapon);
}

event ModeDoFire()
{
    super.ModeDoFire();

    if (Level.NetMode != NM_DedicatedServer)
    {
        MGWeapon.UpdateAmmoBelt();
    }
}

// Overridden to support our hip firing mode
state FireLoop
{
    function BeginState()
    {
        local DHProjectileWeapon RPW;

        NextFireTime = Level.TimeSeconds - 0.1; //fire now!

        RPW = DHProjectileWeapon(Weapon);

        if (!Instigator.bBipodDeployed)
            weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, TweenTime);
        else
            Weapon.LoopAnim(FireIronLoopAnim, IronLoopFireAnimRate, TweenTime);

        PlayAmbientSound(AmbientFireSound);
    }
}

// Overridden to support our hip firing mode
function PlayFireEnd()
{
    local DHProjectileWeapon RPW;

    RPW = DHProjectileWeapon(Weapon);

    if (RPW.HasAnim(FireEndAnim) && !Instigator.bBipodDeployed)
        RPW.PlayAnim(FireEndAnim, FireEndAnimRate, TweenTime);
    else if (RPW.HasAnim(FireIronEndAnim) && Instigator.bBipodDeployed)
        RPW.PlayAnim(FireIronEndAnim, FireEndAnimRate, TweenTime);
}

// Overridden to support hip firing MGs
simulated function HandleRecoil()
{
    local rotator NewRecoilRotation;
    local ROPlayer ROP;
    local ROPawn ROPwn;

    if (Instigator != none)
    {
        ROP = ROPlayer(Instigator.Controller);
        ROPwn = ROPawn(Instigator);
    }

    if (ROP == none || ROPwn == none)
        return;

    if (!ROP.bFreeCamera)
    {
        NewRecoilRotation.Pitch = RandRange(maxVerticalRecoilAngle * 0.75, maxVerticalRecoilAngle);
        NewRecoilRotation.Yaw = RandRange(maxHorizontalRecoilAngle * 0.75, maxHorizontalRecoilAngle);

        if (Rand(2) == 1)
            NewRecoilRotation.Yaw *= -1;

        if (Instigator.Physics == PHYS_Falling)
        {
            NewRecoilRotation *= 3;
        }

        // WeaponTODO: Put bipod and resting modifiers in here
        if (Instigator.bIsCrouched)
        {
            NewRecoilRotation *= PctCrouchRecoil;
        }
        else if (Instigator.bIsCrawling)
        {
            NewRecoilRotation *= PctProneRecoil;
        }

        // player is crouched and in iron sights
        if (Weapon.bUsingSights)
        {
            NewRecoilRotation *= PctHipMGPenalty;
        }

        if (ROPwn.bRestingWeapon)
            NewRecoilRotation *= PctRestDeployRecoil;

        if (Instigator.bBipodDeployed)
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if (ROPwn.LeanAmount != 0)
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        // Need to set this value per weapon
        ROP.SetRecoil(NewRecoilRotation,RecoilRate);
    }

    if (Level.NetMode != NM_DedicatedServer && Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        if (Weapon.bUsingSights)
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTimeIronsight, BlurScaleIronsight);
        }
        else
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTime, BlurScale);
        }
    }
}

// Overridden to support ironsight mode being hipped mode for MGs
function DoFireEffect()
{
    local vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local vector HitLocation, HitNormal;
    local Actor Other;
    local int projectileID;
    local int SpawnCount;
    local float theta;
    local coords MuzzlePosition;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    // if weapon in iron sights, spawn at eye position, otherwise spawn at muzzle tip
    if (Instigator.bBipodDeployed)
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        StartProj = StartTrace + X * ProjSpawnOffset.X;

        // check if projectile would spawn through a wall and adjust start location accordingly
        Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }
    else
    {
        MuzzlePosition = Weapon.GetMuzzleCoords(); //Weapon.GetBoneCoords('Muzzle');

        // Get the muzzle position and scale it down 5 times (since the model is scaled up 5 times in the editor)
        StartTrace = MuzzlePosition.Origin - Weapon.Location;
        StartTrace = StartTrace * 0.2;
        StartTrace = Weapon.Location + StartTrace;

        //Spawn(class'ROEngine.RODebugTracer',Instigator,,StartTrace, rotator(MuzzlePosition.XAxis));

        StartProj = StartTrace + MuzzlePosition.XAxis * FAProjSpawnOffset.X;

        //Spawn(class'ROEngine.RODebugTracer',Instigator,,StartProj, rotator(MuzzlePosition.XAxis));

        Other = Trace(HitLocation, HitNormal, StartTrace, StartProj, true); // was false to only trace worldgeometry

        // Instead of just checking walls, lets check all actors - that way we won't have rounds spawning on the other side of players & missing them altogether - Ramm 10/14/04
        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }
    Aim = AdjustAim(StartProj, AimError);

    // For free-aim, just use where the muzzlebone is pointing
    if (!Instigator.bBipodDeployed && Instigator.weapon.bUsesFreeAim
        && Instigator.IsHumanControlled())
    {
        Aim = rotator(MuzzlePosition.XAxis);
    }

    SpawnCount = Max(1, ProjPerFire * int(Load));

    CalcSpreadModifiers();

    if ((DHMGWeapon(Owner) != none) && DHMGWeapon(Owner).bBarrelDamaged)
    {
        AppliedSpread = 4 * Spread;
    }
    else
    {
        AppliedSpread = Spread;
    }

    switch (SpreadStyle)
    {
        case SS_Random:
            X = vector(Aim);
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                R.Yaw = AppliedSpread * ((FRand()-0.5)/1.5);
                R.Pitch = AppliedSpread * (FRand()-0.5);
                R.Roll = AppliedSpread * (FRand()-0.5);

                HandleProjectileSpawning(StartProj, rotator(X >> R));
            }
            break;

        case SS_Line:
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                theta = AppliedSpread*PI/32768*(projectileID - float(SpawnCount-1)/2.0);
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                HandleProjectileSpawning(StartProj, rotator(X >> Aim));
            }
            break;

        default:
            HandleProjectileSpawning(StartProj, Aim);
    }
}

// Increase spread when firing from the hip
function CalcSpreadModifiers()
{
    super.CalcSpreadModifiers();

    if (!Instigator.bBipodDeployed)
    {
        Spread *= HipSpreadModifier;
    }
}

simulated function EjectShell()
{
    local coords EjectCoords;
    local vector EjectOffset;
    local vector X,Y,Z;
    local rotator EjectRot;
    local ROShellEject Shell;

    if (Instigator.bBipodDeployed)
    {
        if (ShellEjectClass != none)
        {
            Weapon.GetViewAxes(X,Y,Z);

            EjectOffset = Instigator.Location + Instigator.EyePosition();
            EjectOffset = EjectOffset + X * ShellIronSightOffset.X + Y * ShellIronSightOffset.Y +  Z * ShellIronSightOffset.Z;

            EjectRot = rotator(Y);
            EjectRot.Yaw += 16384;
            Shell = Weapon.Spawn(ShellEjectClass,none,,EjectOffset,EjectRot);
            EjectRot = rotator(Y);
            EjectRot += ShellRotOffsetIron;

            EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
            EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
            EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

            Shell.Velocity = (Shell.MinStartSpeed + FRand() * (Shell.MaxStartSpeed-Shell.MinStartSpeed)) * vector(EjectRot);
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

            EjectOffset = EjectOffset + EjectCoords.XAxis * ShellHipOffset.X + EjectCoords.YAxis * ShellHipOffset.Y +  EjectCoords.ZAxis * ShellHipOffset.Z;

            EjectRot = rotator(-EjectCoords.YAxis);
            Shell = Weapon.Spawn(ShellEjectClass,none,,EjectOffset,EjectRot);
            EjectRot = rotator(EjectCoords.XAxis);
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
    PctHipMGPenalty=2.0
    PreLaunchTraceDistance=2624.0
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    BlurTime=0.04
    BlurTimeIronsight=0.04
}

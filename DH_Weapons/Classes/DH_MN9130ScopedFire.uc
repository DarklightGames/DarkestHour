//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedFire extends DHBoltFire;


simulated function HandleRecoil()
{
    local rotator NewRecoilRotation;
    local ROPlayer ROP;
    local ROPawn ROPwn;

    if( Instigator != none )
    {
        ROP = ROPlayer(Instigator.Controller);
        ROPwn = ROPawn(Instigator);
    }

    if( ROP == none || ROPwn == none )
        return;

    if( !ROP.bFreeCamera )
    {
        NewRecoilRotation.Pitch = RandRange( maxVerticalRecoilAngle * 0.75, maxVerticalRecoilAngle );
        NewRecoilRotation.Yaw = RandRange( maxHorizontalRecoilAngle * 0.75, maxHorizontalRecoilAngle );

        if( Rand( 2 ) == 1 )
            NewRecoilRotation.Yaw *= -1;

        if( Instigator.Physics == PHYS_Falling )
        {
            NewRecoilRotation *= 3;
        }

        // WeaponTODO: Put bipod and resting modifiers in here
        if( Instigator.bIsCrouched )
        {
            NewRecoilRotation *= PctCrouchRecoil;

            // player is crouched and in iron sights
            if( Weapon.bUsingSights )
            {
                NewRecoilRotation *= PctCrouchIronRecoil;
            }
        }
        else if( Instigator.bIsCrawling )
        {
            NewRecoilRotation *= PctProneRecoil;

            // player is prone and in iron sights
            if( Weapon.bUsingSights )
            {
                NewRecoilRotation *= PctProneIronRecoil;
            }
        }
        else if( Weapon.bUsingSights )
        {
            NewRecoilRotation *= PctStandIronRecoil;
        }

        if( ROPwn.bRestingWeapon )
            NewRecoilRotation *= PctRestDeployRecoil;

        if( Instigator.bBipodDeployed )
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if( ROPwn.LeanAmount != 0 )
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        // Need to set this value per weapon
        ROP.SetRecoil(NewRecoilRotation,RecoilRate);
    }

// Add Fire Blur
    if( Level.NetMode != NM_DedicatedServer )
    {
        if( Instigator != None )
        {
            if( ROPlayer( Instigator.Controller ) != None )
            {
                if( Weapon.bUsingSights )
                {
                    ROPlayer( Instigator.Controller ).AddBlur( 0.1, 0.1 );
                }
                else
                {
                    ROPlayer( Instigator.Controller ).AddBlur( 0.01, 0.1 );
                }
            }
        }
    }
}

defaultproperties
{
    //** Ammo properties **//
    AmmoClass=class'MN762x54RAmmo'
    AmmoPerFire=1

    //** Projectile firing **//
    ProjectileClass = class'DH_Weapons.DH_MN9130ScopedBullet'
    ProjSpawnOffset=(X=25,Y=0,Z=0)
    FAProjSpawnOffset=(X=-35,Y=0,Z=0)
    SpreadStyle=SS_Random
    Spread = 25

    //** Shell Ejection **//
    ShellIronSightOffset=(X=10,Y=3,Z=-5)
    ShellHipOffset=(X=0,Y=0,Z=0)
    //ShellRotOffsetIron=(Pitch=0,Yaw=0,Roll=0)
    //ShellRotOffsetHip=(Pitch=5000,Yaw=0,Roll=0)

    //** Recoil **//
    maxVerticalRecoilAngle=1500
    maxHorizontalRecoilAngle=100
    PctRestDeployRecoil=0.25

    //** Functionality **//
    bWaitForRelease = true // Set to true for non automatic weapons

    //** Animation **//
    // Rates
    FireAnimRate=1.0
    FireRate=2.4
    TweenTime=0.0
    // Firing
    FireAnim=Shoot_Last
    FireIronAnim=Scope_shoot

    //** Sounds **//
    FireSounds(0) = Sound'Inf_Weapons.nagant9130.nagant9130_fire01'
    FireSounds(1) = Sound'Inf_Weapons.nagant9130.nagant9130_fire02'
    FireSounds(2) = Sound'Inf_Weapons.nagant9130.nagant9130_fire03'

    //** Effects **//
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    SmokeEmitterClass = class'ROEffects.ROMuzzleSmoke'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'

    //** Bot/AI **//
    bSplashDamage=false
    bRecommendSplashDamage=false
    bSplashJump=false
    BotRefireRate=0.5
    WarnTargetPct=+0.9
    AimError=500

    //** View shake **//
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)//(X=1000.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0//1.0

    //** Misc **//
    FireForce="RocketLauncherFire"  // jdf
}
//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDBullet extends DHBullet;

var     float       DHPenetrationTable[11];

var     float       ShellDiameter;                  // to assist in T/d calculations

// Shatter
var     bool        bShatterProne;                  // assists with shatter gap calculations

var()   class<Emitter>  ShellShatterEffectClass;    // Effect for this shell shattering against a vehicle
var     sound           ShatterVehicleHitSound;     // sound of this shell shattering on the vehicle
var     sound           ShatterSound[4];            // sound of the round exploding

// Deflection
var     sound VehicleHitSound;
var()   class<Emitter>  ShellHitVehicleEffectClass;

var byte HitCount;      // How many times we have hit something

// Impact Damage
var     class<DamageType>   ShellImpactDamage;
var     int                 ImpactDamage;

var vector LaunchLocation;

// Debugging code - set to false on release
var     bool    bDebuggingText;

// This function was having some wierd effects - Ramm
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    LaunchLocation = location;
}

//-----------------------------------------------------------------------------
// Tick - Update physics
//-----------------------------------------------------------------------------

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    // Bit of a hack, bCollideActors gets replicated too soon so we don't get
    // the hitwall call client side to do our hit effects. This will prevent
    // that.
    if( HitCount == 0 && !bCollideActors && Level.NetMode == NM_Client)
    {
        SetCollision(True,True);
    }
}


//Borrowed from AB: Just using a standard linear interpolation equation here
simulated function float GetPenetration(vector Distance)
{
    local float MeterDistance;
    local float PenetrationNumber;

    MeterDistance = VSize(Distance)/60.352;

    //Distance debugging
    //log(self$" traveled "$MeterDistance$" meters for penetration calculations");
    //Level.Game.Broadcast(self, self$" traveled "$MeterDistance$" meters for penetration calculations");

    if      ( MeterDistance < 100)  PenetrationNumber = ( DHPenetrationTable[0] + (100 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 100 );
    else if ( MeterDistance < 250)  PenetrationNumber = ( DHPenetrationTable[1] + (250 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 150 );
    else if ( MeterDistance < 500)  PenetrationNumber = ( DHPenetrationTable[2] + (500 - MeterDistance) * (DHPenetrationTable[1]-DHPenetrationTable[2]) / 250 );
    else if ( MeterDistance < 750)  PenetrationNumber = ( DHPenetrationTable[3] + (750 - MeterDistance) * (DHPenetrationTable[2]-DHPenetrationTable[3]) / 250 );
    else if ( MeterDistance < 1000) PenetrationNumber = ( DHPenetrationTable[4] + (1000 - MeterDistance) * (DHPenetrationTable[3]-DHPenetrationTable[4]) / 250 );
    else if ( MeterDistance < 1250) PenetrationNumber = ( DHPenetrationTable[5] + (1250 - MeterDistance) * (DHPenetrationTable[4]-DHPenetrationTable[5]) / 250 );
    else if ( MeterDistance < 1500) PenetrationNumber = ( DHPenetrationTable[6] + (1500 - MeterDistance) * (DHPenetrationTable[5]-DHPenetrationTable[6]) / 250 );
    else if ( MeterDistance < 1750) PenetrationNumber = ( DHPenetrationTable[7] + (1750 - MeterDistance) * (DHPenetrationTable[6]-DHPenetrationTable[7]) / 250 );
    else if ( MeterDistance < 2000) PenetrationNumber = ( DHPenetrationTable[8] + (2000 - MeterDistance) * (DHPenetrationTable[7]-DHPenetrationTable[8]) / 250 );
    else if ( MeterDistance < 2500) PenetrationNumber = ( DHPenetrationTable[9] + (2500 - MeterDistance) * (DHPenetrationTable[8]-DHPenetrationTable[9]) / 500 );
    else if ( MeterDistance < 3000) PenetrationNumber = ( DHPenetrationTable[10] + (3000 - MeterDistance) * (DHPenetrationTable[9]-DHPenetrationTable[10]) / 500 );
    else PenetrationNumber = DHPenetrationTable[10];

    return PenetrationNumber;

}

//DH CODE: Returns (T/d) for APC/APCBC shells
simulated function float GetOverMatch (float ArmorFactor, float ShellDiameter)
{
    local float OverMatchFactor;

    OverMatchFactor = ( ArmorFactor / ShellDiameter );

    return OverMatchFactor;

}

//-----------------------------------------------------------------------------
// ProcessTouch - We hit something, so damage it if it's a player
//-----------------------------------------------------------------------------
/* commented out for compile
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local Vector    X, Y, Z;
    local float V;
    local bool  bHitWhipAttachment;
    local ROPawn HitPawn;
    local ROVehicle HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local bool bHitVehicleDriver;
    local Vector TempHitLocation, HitNormal;
    local array<int>    HitPoints;

    local float         TouchAngle;     // dummy variable

    if (Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces )
        return;

    HitCount++;

    TouchAngle=1.57;

    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);

    if( HitVehicleWeapon != none && HitVehicle != none )
    {
        if ( HitVehicleWeapon.HitDriverArea(HitLocation, Velocity) )
        {
            if( HitVehicleWeapon.HitDriver(HitLocation, Velocity) )
            {
                bHitVehicleDriver = true;
            }
            else
            {
                return;
            }
        }

        if ( HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateAPDS( HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellImpactDamage, bShatterProne))
        {
            if(bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Turret Ricochet!");
            }

            if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
            {
               // Spawn the bullet hit effect client side
               if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
               {
                  PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume,,,1.5);
                  Spawn(class'TankAPHitDeflect',,, Location + HitNormal*16,rotator(HitNormal));
               }
               return;
            }
            else
            {
               // Shell shatter
               if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
               {
                  PlaySound(ShatterVehicleHitSound,,5.5*TransientSoundVolume);
                  Spawn(ShellShatterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                  PlaySound(ShatterSound[Rand(4)],,5.5*TransientSoundVolume);
               }
               return;
            }
        }

        if (Role == ROLE_Authority)
        {
            if ( bHitVehicleDriver )
            {
                HitVehicleWeapon.TakeDamage(Damage - 20 * (1 - VSize(Velocity) / default.Speed), instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
            }
            else
            {
                HitVehicle.TakeDamage(Damage - 20 * (1 - VSize(Velocity) / default.Speed), instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
            }

            MakeNoise(1.0);
        }

        if ( Level.NetMode != NM_DedicatedServer)
        {
            PlaySound(VehicleHitSound,,5.5*TransientSoundVolume,,,1.5);
            if ( EffectIsRelevant(Location,false) )
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation,rotator(Normal(-Velocity)));
            }
        }

        // Give the bullet a little time to play the hit effect client side before destroying the bullet
        if (Level.NetMode == NM_DedicatedServer)
        {
            bCollided = true;
            SetCollision(False,False);
        }
        else
        {
            Destroy();
        }

        return;
    }

    V = VSize(Velocity);

    // If the bullet collides right after launch, it doesn't have any velocity yet.
    // Use the rotation instead and give it the default speed - Ramm
    if( V < 25 )
    {
        GetAxes(Rotation, X, Y, Z);
        V=default.Speed;
    }
    else
    {
        GetAxes(Rotator(Velocity), X, Y, Z);
    }

    if( ROBulletWhipAttachment(Other) != none )
    {
        bHitWhipAttachment=true;

        if(!Other.Base.bDeleteMe)
        {
            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, 1);

            if( Other == none )
                return;

            HitPawn = ROPawn(Other);
        }
        else
        {
            return;
        }
    }

    if (V > MinPenetrateVelocity * ScaleFactor)
    {
        if (Role == ROLE_Authority)
        {
            if ( HitPawn != none )
            {
                 if(!HitPawn.bDeleteMe)
                    HitPawn.ProcessLocationalDamage(Damage - 20 * (1 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);
                 bHitWhipAttachment = false;
            }
            else
            {
                Other.TakeDamage(Damage - 20 * (1 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
            }
        }
        else
        {

            if ( HitPawn != none )
            {
                bHitWhipAttachment = false;
            }
        }
    }

    if( !bHitWhipAttachment )
        Destroy();
}*/

//-----------------------------------------------------------------------------
// HitWall - The bullet hit a wall
//-----------------------------------------------------------------------------
/* commented out for compile
simulated function HitWall(vector HitNormal, actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;

    local float HitAngle;

    HitAngle=1.57;

    DestroMesh = RODestroyableStaticMesh(Wall);

    if ( WallHitActor != none && WallHitActor == Wall)
    {
        return;
    }
    WallHitActor = Wall;

    HitCount++;

    if ( Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateAPDS( Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bShatterProne))
    {

        if(bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hull Ricochet!");
        }

            if (!bShatterProne || !DH_ROTreadcraft(Wall).bRoundShattered)
            {
               // Spawn the bullet hit effect client side
               if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
               {
                  PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume,,,1.5);
                  Spawn(class'TankAPHitDeflect',,, Location + HitNormal*16,rotator(HitNormal));
               }
               return;
            }
            else
            {
               // Shell shatter
               if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
               {
                  PlaySound(ShatterVehicleHitSound,,5.5*TransientSoundVolume);
                  Spawn(ShellShatterEffectClass,,,Location + HitNormal*16,rotator(HitNormal));
                  PlaySound(ShatterSound[Rand(4)],,5.5*TransientSoundVolume);
               }
               return;
            }
    }

    if (Role == ROLE_Authority)
    {
        if ( Mover(Wall) != None || DestroMesh != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
            Wall.TakeDamage(Damage - 20 * (1 - VSize(Velocity) / default.Speed), instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
        MakeNoise(1.0);
    }

    if ( Wall.IsA('ROVehicle') && (Level.NetMode != NM_DedicatedServer))
    {
        PlaySound(VehicleHitSound,,5.5*TransientSoundVolume,,,1.5);
        if ( EffectIsRelevant(Location,false) )
        {
            Spawn(ShellHitVehicleEffectClass,,,Location + HitNormal*16,rotator(HitNormal));
        }
    }
    else if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
    {
        Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
    }

    if (bDebugBallistics && Level.NetMode != NM_DedicatedServer)
        Spawn(class 'RODebugTracer',self,,Location,Rotation);

    // Don't want to destroy the bullet if its going through something like glass
    if( DestroMesh != none && DestroMesh.bWontStopBullets )
    {
        return;
    }

    // Give the bullet a little time to play the hit effect client side before destroying the bullet
     if (Level.NetMode == NM_DedicatedServer)
     {
        bCollided = true;
        SetCollision(False,False);
     }
     else
     {
        Destroy();
     }
}*/



defaultproperties
{
    bShatterProne=true
    BallisticCoefficient=0.675
    Speed=60956
    MaxSpeed=60956

    SpeedFudgeScale=0.7

    ShellDiameter=1.45

    Tag="B-32"

    ImpactDamage=125
    ShellImpactDamage=class'DH_Weapons.DH_PTRDBulletShellDamageAP'
    MyDamageType=class'DH_Weapons.DH_PTRDDamType'
    Damage=125.0

    DHPenetrationTable[0]=3.5  //100
    DHPenetrationTable[1]=2.4  //250
    DHPenetrationTable[2]=1.5  //500
    DHPenetrationTable[3]=1.0   //750
    DHPenetrationTable[4]=0.0   //1000
    DHPenetrationTable[5]=0.0   //1250
    DHPenetrationTable[6]=0.0   //1500
    DHPenetrationTable[7]=0.0   //1750
    DHPenetrationTable[8]=0.0  //2000
    DHPenetrationTable[9]=0.0   //2500
    DHPenetrationTable[10]=0.0  //3000

    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    //Compile error  ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatterSmall'
    ShatterVehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ShatterSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ShatterSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ShatterSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ShatterSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    bDebuggingText=false
}

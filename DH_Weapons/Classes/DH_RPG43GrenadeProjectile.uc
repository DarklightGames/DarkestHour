//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeProjectile extends DH_StielGranateProjectile;

#exec OBJ LOAD File=Inf_WeaponsTwo.uax

var float DestroyTimer, SurfaceAngleRadian, RPG43PenetrationAbility;
var bool bCalledDestroy, bIsHEATRound;
var class<DamageType> GrenadeImpactDamage;

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

simulated function HitWall(vector HitNormal, actor Wall)
{
    local vector VNorm;
    local ESurfaceTypes ST;
    local float HitAngle;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    // Return here, this was causing the famous "Nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    // Subtract bounce number
    Bounces--;

    //Set hitangle
    HitAngle = 1.57;  //Pointless number

    if( VSize(Velocity) >= 820 + Rand(81))
    {
        //Lets check if we hit a vehicle (but not passenger pawn)
        if( Wall.IsA('SVehicle') && !Wall.IsA('ROPassengerPawn') )
        {
            //Lets fuck up the vehicle hard core if we hit a top and flat surface
            if(Acos(HitNormal dot vect(0, 0, 1)) < SurfaceAngleRadian)
            {
                //Hurt the vehicle itself
                Wall.TakeDamage(Damage*1.5, none, Location, Location, MyDamageType);
                explode(Location,vect(0,0,0));
            }
            else //else lets check if the armor is too thick to damage
            {
                explode(Location,vect(0,0,0));
            }
            //Because we exploded, let's end the function here
            return;
        }
        //we didn't hit a vehicle, ground can be softer so lets be harsher on velocity
        else if( VSize(Velocity) >= 950 + Rand(101) )
        {
            explode(Location,vect(0,0,0));
            //Because we exploded, let's end the function here
            return;
        }
    }

    //We didn't hit the wall hard enough so lets try bouncing
    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall w/damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Speed = VSize(Velocity);
    }

    if ((Level.NetMode != NM_DedicatedServer) && (Speed > 150) && ImpactSound != none )
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // Increase volume of impact
    }
}

//Overrided because there is no fuse on this grenade
simulated function Tick(float DeltaTime)
{
    //Count down on the destroy timer
    DestroyTimer -= DeltaTime;

    if (DestroyTimer <= 0.0 && !bCalledDestroy)
    {
        bCalledDestroy = true;
        bAlreadyExploded = true; //Make sure it doesnt' explode on destroy
        Reset(); //delete the actor
    }
}

//Overrideen to support alreadyexploded variable
simulated function Destroyed()
{
    local Vector Start;
    local ESurfaceTypes ST;

    if (bAlreadyExploded)
        return;

    PlaySound(ExplosionSound[Rand(3)],, 5.0);
    Start = Location + 32 * vect(0,0,1);

    DoShakeEffect();

    if (EffectIsRelevant(Location,false))
    {
        // if the grenade is still moving we'll need to spawn a different explosion effect
        if (Physics == PHYS_Falling)
        {
            Spawn(class'GrenadeExplosion_midair',,, Start, rotator(vect(0, 0, 1)));
        }

        // if the grenade has stopped and is on the ground we'll spawn a ground explosion
        // effect and spawn some dirt flying out
        else if (Physics == PHYS_None)
        {
            GetHitSurfaceType(ST, vect(0,0,1));

            if (ST == EST_Snow || ST == EST_Ice)
            {
                Spawn(ExplodeDirtEffectClass,,, Start, rotator(vect(0,0,1)));
                Spawn(ExplosionDecalSnow, self,, Location, rotator(-vect(0,0,1)));
            }
            else
            {
                Spawn(ExplodeDirtEffectClass,,, Start, rotator(vect(0,0,1)));
                Spawn(ExplosionDecal, self,, Location, rotator(-vect(0,0,1)));
            }
        }
    }

    super.Destroyed();
}

defaultproperties
{
     bIsHEATRound=True
     //compile error  GrenadeImpactDamage=class'DH_Vehicles.DH_TankShellImpactDamage'
     RPG43PenetrationAbility=7.6
     SurfaceAngleRadian=0.1195555555555556
     DestroyTimer=15.000000 //Used incase the grenade didn't hit hard enough to explode (will stay around for a bit for effect)
     //SmokeSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
     ExplodeDirtEffectClass=Class'ROEffects.GrenadeExplosion'
     ExplosionSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
     ExplosionSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
     ExplosionSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
     Damage=200.000000
     DamageRadius=250.000000
     MyDamageType=class'DH_Weapons.DH_RPG43GrenadeDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.RPG43_Tossed'
     bAlwaysRelevant=True
     LifeSpan=30.000000
     SoundVolume=255
     SoundRadius=200.000000
     FuzeLengthTimer=0.0
     Speed=900.000000
     bUseCollisionStaticMesh=True
}

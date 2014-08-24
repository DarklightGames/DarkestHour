//=============================================================================
// SatchelCharge10lb10sProjectile
//=============================================================================
// Satchel projectile for the 10lb 10second satchel charge
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

//=============================================================================

class DH_SatchelCharge10lb10sProjectile extends SatchelCharge10lb10sProjectile;

// Shake the ground for poeple near the artillery hit
// Now also knocks players to the ground - PsYcH0_Ch!cKeN
/*simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, scale;

    //viewshake
    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();
        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);
            if (Dist < DamageRadius * ShakeScale)
            {
                scale = (DamageRadius*ShakeScale - Dist) / (DamageRadius*ShakeScale);
                scale *= BlurEffectScalar;

                PC.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);

                if (PC.Pawn != none && DH_Pawn(PC.Pawn) != none)
                {
                    scale = scale - (Scale * 0.50 - ((Scale * 0.50) * DH_Pawn(PC.Pawn).GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity))));
                }
                DHPlayer(PC).AddBlur(BlurTime*Scale, FMin(1.0,Scale));

                if (!DH_Pawn(PC.Pawn).bIsCrawling && (Dist < DamageRadius + (DamageRadius*ShakeScale - DamageRadius) / 2))
                {
//                   DH_Pawn(PC.Pawn).StartProneDive(42); // 42 is the HeightAdjust value set by the engine when it calls this function
                   DHPlayer(PC).Prone();
                }

                // Hint check
                DHPlayer(PC).CheckForHint(13);
            }
        }
    }
}*/

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_none);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)),QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker');
            Fear.SetCollisionSize(DamageRadius,200);
            Fear.StartleBots();
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     Damage=600.000000
     DamageRadius=725.000000
     MyDamageType=Class'DH_Weapons.DH_SatchelDamType'
     CollisionRadius=4.000000
     CollisionHeight=4.000000
}

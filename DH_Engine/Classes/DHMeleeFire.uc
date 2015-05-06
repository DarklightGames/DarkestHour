//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMeleeFire extends ROMeleeFire
    abstract;

var protected float         BehindDamageFactor; // Damage factor for when meleeing player is behind another
var protected float         RearAngleArc; // Angle in UU angles for a player's rear (used to calculate rear melee hits)

const SoundRadius = 32.0;

function DoTrace(vector Start, rotator Dir)
{
    local vector End, HitLocation, HitNormal;
    local Actor Other;
    local ROPawn HitPawn;
    local int Damage;
    local class<DamageType> ThisDamageType;
    local array<int> HitPoints;
    local array<int> DamageHitPoint;
    local float scale;
    local int i;
    local rotator RotationDifference;
    local vector TempVec;
    local vector X, Y, Z;

    GetAxes(Dir, X, Y, Z);

    // HitPointTraces don't really like very short traces, so we have to do a long trace first, then see
    // if the player we hit was within range
    End = Start + 10000 * X;

    // do precision hit point trace to see if we hit a player or something else
    Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start);

    if (Other == none || VSizeSquared(Start - HitLocation) > GetTraceRangeSquared())
    {
        for (i = 0; i < 4; ++i)
        {
            switch (i)
            {
                // Lower Left
                case 0:
                    TempVec = (Start - MeleeAttackSpread * Y) - MeleeAttackSpread * Z;
                    break;
                // Upper Right
                case 1:
                    TempVec = (Start + MeleeAttackSpread * Y) + MeleeAttackSpread * Z;
                    break;
                // Upper Left
                case 2:
                    TempVec = (Start - MeleeAttackSpread * Y) + MeleeAttackSpread * Z;
                    break;
                // Lower Right
                case 3:
                    TempVec = (Start + MeleeAttackSpread * Y) - MeleeAttackSpread * Z;
                    break;
            }

            End = TempVec + 10000 * X;

            Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, TempVec);

            if (Other != none)
            {
                if (VSizeSquared(Start - HitLocation) < GetTraceRangeSquared())
                {
                    break;
                }

                Other = none;
            }
        }
    }

    if (Other != none && (VSizeSquared(Start - HitLocation) > GetTraceRangeSquared()))
    {
        return;
    }

    if (Other == none)
    {
        Other = Instigator.Trace(HitLocation, HitNormal, End, Start, true);

        if (VSizeSquared(Start - HitLocation) > GetTraceRangeSquared())
        {
            return;
        }

        if (Other != none && !Other.bWorldGeometry)
        {
            if (Other.IsA('Vehicle'))
            {
                if (Weapon.bBayonetMounted)
                {
                    Weapon.PlaySound(GroundStabSound, SLOT_None, FireVolume,, SoundRadius,, true);
                }
                else
                {
                    Weapon.PlaySound(GroundBashSound, SLOT_None, FireVolume,, SoundRadius,, true);
                }
            }

            return;
        }
    }

    if (Other != none && Other != Instigator && Other.Base != Instigator)
    {
        scale = (FClamp(HoldTime, MinHoldTime, FullHeldTime) - MinHoldTime) / (FullHeldTime - MinHoldTime); // result 0 to 1
        RotationDifference = Normalize(Other.Rotation) - Normalize(Instigator.Rotation);

        if (Weapon.bBayonetMounted)
        {
            if (abs(RotationDifference.Yaw) <= RearAngleArc)
            {
                Damage = BayonetDamageMin * BehindDamageFactor + scale * (BayonetDamageMax - BayonetDamageMin);
            }
            else
            {
                Damage = BayonetDamageMin + scale * (BayonetDamageMax - BayonetDamageMin);
            }

            ThisDamageType = BayonetDamageType;
        }
        else
        {
            if (abs(RotationDifference.Yaw) <= RearAngleArc)
            {
                Damage = DamageMin * BehindDamageFactor + scale * (DamageMax - DamageMin);
            }
            else
            {
                Damage = DamageMin + scale * (DamageMax - DamageMin);
            }

            ThisDamageType = DamageType;
        }

        if (!Other.bWorldGeometry)
        {
            // Update hit effect except for pawns (blood) other than vehicles.
            if (Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')))
            {
                WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
            }

            HitPawn = ROPawn(Other);

            if (HitPawn != none)
            {
                 if (!HitPawn.bDeleteMe)
                 {
                    if (HitPoints.Length > 0)
                    {
                        DamageHitPoint[0] = HitPoints[HitPawn.GetHighestDamageHitIndex(HitPoints)];
                    }
                    else
                    {
                        DamageHitPoint[0] = 0;
                    }

                    HitPawn.ProcessLocationalDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, ThisDamageType, DamageHitPoint);

                    if (Weapon.bBayonetMounted)
                    {
                        Weapon.PlaySound(PlayerStabSound, SLOT_None, FireVolume,, SoundRadius,, true);
                    }
                    else
                    {
                        Weapon.PlaySound(PlayerBashSound, SLOT_None, 1.0,, SoundRadius,, true);
                    }
                 }
            }
            else
            {
                if (Weapon.bBayonetMounted)
                {
                    Weapon.PlaySound(GroundStabSound, SLOT_None, FireVolume,, SoundRadius,, true);
                }
                else
                {
                    Weapon.PlaySound(GroundBashSound, SLOT_None, FireVolume,, SoundRadius,, true);
                }

                Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, ThisDamageType);
            }

            HitNormal = vect(0.0, 0.0, 0.0);
        }
        else
        {
            if (RODestroyableStaticMesh(Other) != none)
            {
                Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * X, ThisDamageType);
            }

            if (WeaponAttachment(Weapon.ThirdPersonActor) != none)
            {
                WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
            }

            if (Weapon.bBayonetMounted)
            {
                Weapon.PlaySound(GroundStabSound, SLOT_None, FireVolume,, SoundRadius,, true);
            }
            else
            {
                Weapon.PlaySound(GroundBashSound, SLOT_None, FireVolume,, SoundRadius,, true);
            }
        }
    }
}

defaultproperties
{
    BehindDamageFactor=3.0
    RearAngleArc=16000.0

    DamageMin=20
    DamageMax=33
    BayonetDamageMin=30
    BayonetDamageMax=45
    MinHoldtime=0.1
    FullHeldTime=0.2
    MeleeAttackSpread=8.0
    MomentumTransfer=0

    FireRate=0.25
    FireAnimRate=1.0
}
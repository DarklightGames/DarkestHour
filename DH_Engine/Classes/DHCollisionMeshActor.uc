//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCollisionMeshActor extends StaticMeshActor
    notplaceable;

/**
Matt, July 2015: this actor is a way of getting a collision static mesh to work on a VehicleWeapon (generally a turret, but maybe an exposed MG or a gun shield)

You can see in the RO vehicle static mesh packages that turret col meshes were made, but are not used (DH also had 1 or 2 in 5.1).
Instead turrets only have simple box collision, which give only crude hit detection. TWI must have hit a problem, so why weren't the turret col meshes used?
The answer is that in UT2004 skeletal meshes, a col mesh can't be attached to a bone, only to the skeletal mesh origin.
That works fine for a vehicle hull, but a VehicleWeapon actor always faces directly forwards, relative to the hull.
The actual VW actor doesn't rotate relative to the vehicle, only it's yaw bone rotates, which makes the mesh visibly turn - but the actual actor itself isn't rotating.
So the VW col mesh, which is attached to the origin, always stays facing forwards, relative to the hull.
As soon as the weapon rotates, the col mesh is no longer aligned with the weapon & hit detection is completely screwed up.
The 1 RO vehicle that does use a turret col mesh is the tiger - to see the screwed up result, in single player type "show collision" in console, rotate turret & take a look !!

This is a workaround that solves the problem. This is the sequence of events, which is actually very simple:
1. If a CollisionStaticMesh has been specified in the WV class, the VW spawns a separate col mesh actor in PostBeginPlay, with the VW as col mesh's owner.
2. VW attaches col mesh actor to VW's YawBone - col mesh will now rotate with the VW.
3. VW removes all of its own collision, so no hit will ever be detected on the VW itself.
4. Col mesh actor copies the VW's normal collision properties, so projectiles will hit the col mesh in the same way & trigger the usual functionality.
5. All relevant projectile (& related) hit detection functions begin by checking if the hit actor is a col mesh actor.
6. If a projectile has hit a col mesh actor, it simply switches the hit actor to be the col mesh's owner, which is the actual VW.
7. The hit detection functionality then simply continues as if it had hit the actual VW, with the usual hit & penetration calcs & results.
8. For other collision, e.g. a player walking on a turret, the col mesh actor also handles that as if the colliding actor had collided with the actual VW
   (although the col mesh uses simple 'box' collision for players (they use a non-zero extent trace), instead of complex, per-polygon collision).

To set up a VW col mesh actor the process is:
1. Make a simplified static mesh version of the VW skeletal mesh, with one material slot.
2. Import the col mesh into a DH static mesh file & name it something like MyVehicle_turret_coll.
3. Give it the properties of any 'normal' col static mesh (Material = none, true for EnableCollision, UseSimpleKarmaCollision & UseSimpleBoxCollision, false for others).
4. Add CollisionStaticMesh=StaticMesh'DH_TheStaticMeshPackage.MyVehicle_turret_coll' to the VW's default properties.

When modelling a new VW col mesh, e.g. a tank turret:
- Keep the mesh simple, with as few triangles as possible - just model the main shape of the turret, where a shell may potentially hit & destroy.
- Do not use the actual turret model as a col mesh, as it's unnecessarily detailed for collision calcs, which should always be a simple as possible.
- So just use the actual turret model as a template for the shape of your new, simple col mesh.
- Do not include a cannon barrel as if it's hit by a shell it may well cause the whole vehicle to explode.
- Avoid convex angles in the col mesh, as static mesh collision detection doesn't like that, so where necessary split the mesh into separate, convex, 'closed' parts

Ps - A col mesh actor can be used to represent things other than VehicleWeapons, e.g. driver's armoured visors on halftracks, attached to open & close with hull's visor bone
*/

// Options to control what kind of projectile or damage this collision actor will stop (stops all by default)
var     bool    bWontStopBullet;           // won't stop a DHBullet
var     bool    bWontStopShell;            // won't stop a DHAntiVehicleProjectile, e.g. a cannon shell (also includes AT rocket)
var     bool    bWontStopBlastDamage;      // won't stop blast damage caused by HurtRadius function
var     bool    bWontStopThrownProjectile; // won't stop a DHThrowableExplosiveProjectile, e.g. grenade or satchel (hard to see utility, but included for completeness)

var     bool    bIsBulletProof;            // col mesh is bullet proof, i.e. resistant to small arms fire - used to attach armour attachments to a soft skin vehicle

// Modified to copy the owning actor's collision properties
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Owner != none)
    {
        SetCollision(Owner.default.bCollideActors, Owner.default.bBlockActors);
        bCollideWorld = Owner.default.bCollideWorld;
        SetCollisionSize(Owner.CollisionRadius, Owner.CollisionHeight);
        KSetBlockKarma(Owner.default.bBlockKarma);
        bBlockZeroExtentTraces = Owner.default.bBlockZeroExtentTraces;
        bBlockNonZeroExtentTraces = Owner.default.bBlockNonZeroExtentTraces;
        bBlockHitPointTraces = Owner.default.bBlockHitPointTraces;
        bProjTarget = Owner.default.bProjTarget;
        bUseCollisionStaticMesh = Owner.default.bUseCollisionStaticMesh;
        bIgnoreEncroachers = Owner.default.bIgnoreEncroachers;

        bCanAutoTraceSelect = Owner.default.bCanAutoTraceSelect;
        bAutoTraceNotify = Owner.default.bAutoTraceNotify;
    }
    else
    {
        Warn(Tag @ "somehow spawned without an Owner, so is being destroyed");
        Destroy();
    }
}

// New function to spawn, attach & align a collision static mesh actor (used by the classes that spawn a col mesh)
simulated static function DHCollisionMeshActor AttachCollisionMesh(Actor ColMeshOwner, StaticMesh ColStaticMesh,
    name AttachBone, optional vector AttachOffset, optional class<DHCollisionMeshActor> ColMeshActorClass)
{
    local DHCollisionMeshActor ColMeshActor;

    if (AttachBone == '' || ColMeshOwner == none)
    {
        return none;
    }

    if (ColMeshActorClass == none)
    {
        ColMeshActorClass = class'DHCollisionMeshActor'; // default is base col mesh class, but a specialised subclass can be specified if desired
    }

    ColMeshActor = ColMeshOwner.Spawn(ColMeshActorClass, ColMeshOwner); // vital that the actor that spawns the col mesh is its owner

    if (ColMeshActor != none)
    {
        // Attach col mesh actor to specified attachment bone, so the col mesh will move with the relevant part of the owning actor
        ColMeshOwner.AttachToBone(ColMeshActor, AttachBone);

        // Apply a positional offset if one has been specified
        if (AttachOffset != vect(0.0, 0.0, 0.0))
        {
            ColMeshActor.SetRelativeLocation(AttachOffset);
        }
        // But usually the col mesh has been modelled on the owning actor's mesh origin, but is now centred on the attachment bone, so reposition it to align with owning mesh
        else
        {
            ColMeshActor.SetRelativeRotation(ColMeshOwner.Rotation - ColMeshOwner.GetBoneRotation(AttachBone)); // as attachment bone may be modelled with rotation in reference pose
            ColMeshActor.SetRelativeLocation((ColMeshOwner.Location - ColMeshOwner.GetBoneCoords(AttachBone).Origin) << (ColMeshOwner.Rotation - ColMeshActor.RelativeRotation));
        }

        // Finally set the static mesh for the col mesh actor (may be none, if using a subclass of DHCollisionMeshActor & that already specifies a static mesh)
        if (ColStaticMesh != none)
        {
            ColMeshActor.SetStaticMesh(ColStaticMesh);
        }
    }

    return ColMeshActor;
}

// Implemented here so player gets an enter vehicle message when looking at a col mesh actor representing a vehicle weapon or vehicle
simulated event NotifySelected(Pawn User)
{
    if (Owner != none)
    {
        Owner.NotifySelected(User);
    }
}

// Col mesh actor should never take damage, so just in case we'll call TakeDamage on the owning actor, which would have otherwise have received the damage call
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Owner.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);
}

// New debug helper function to toggle whether the col mesh is visible or not
simulated function ToggleVisible()
{
    if (DrawType == default.DrawType)
    {
        SetDrawType(DT_StaticMesh); // show
    }
    else
    {
        SetDrawType(default.DrawType); // hide
    }
}

// New debug helper function to hide or re-show the owning actor
// Can't simply set owner as DrawType=none or bHidden, as that also hides all attached actors, including col mesh & player, so we skin with an alpha transparency texture
simulated function HideOwner(bool bHide)
{
    local DHVehicle V;
    local bool      bUseCannonSkinsArray, bMatchMGSkinToVehicle;
    local int       i;

    if (!bHide)
    {
        V = DHVehicle(Owner.Base);

        if (V != none)
        {
            if (Owner.IsA('DHVehicleCannon'))
            {
                bUseCannonSkinsArray = V.CannonSkins.Length > 0;
            }
            else if (Owner.IsA('DHVehicleMG'))
            {
                bMatchMGSkinToVehicle = DHVehicleMG(Owner).bMatchSkinToVehicle;
            }
        }
    }

    for (i = 0; i < Owner.Skins.Length; ++i)
    {
        if (bHide)
        {
            Owner.Skins[i] = Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha';
        }
        else if (bUseCannonSkinsArray && i < V.CannonSkins.Length && V.CannonSkins[i] != none)
        {
            Owner.Skins[i] = V.CannonSkins[i];
        }
        else if (bMatchMGSkinToVehicle && i == 0)
        {
            Owner.Skins[i] = V.Skins[i];
        }
        else
        {
            Owner.Skins[i] = Owner.default.Skins[i];
        }
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_None // can't use bHidden=true because that stops the auto-trace system from registering the col mesh when player looks at it
    bWorldGeometry=false
    bStatic=false
    bHardAttach=true
    bBlockKarma=false
    bShadowCast=false
    bStaticLighting=false
    bUseDynamicLights=false
    bAcceptsProjectors=false
    bCanAutoTraceSelect=true // so player gets an enter vehicle message when looking at a vehicle weapon, not just its hull or base
    bAutoTraceNotify=true
}

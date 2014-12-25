//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WaterVolume extends PhysicsVolume;

var string EntrySoundName;
var string ExitSoundName;
var string EntryActorName;
var string PawnEntryActorName;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (EntrySound == none && EntrySoundName != "")
    {
        EntrySound = Sound(DynamicLoadObject(EntrySoundName, class'Sound'));
    }

    if (ExitSound == none && ExitSoundName != "")
    {
        ExitSound = Sound(DynamicLoadObject(ExitSoundName, class'Sound'));
    }

    if (EntryActor == none && EntryActorName != "")
    {
        EntryActor = class<Actor>(DynamicLoadObject(EntryActorName, class'class'));
    }

    if (PawnEntryActor == none && PawnEntryActorName != "")
    {
        PawnEntryActor = class<Actor>(DynamicLoadObject(PawnEntryActorName, class'class'));
    }
}

//Allows the ability to get cleansed of fire and projectile splash effects
simulated event Touch(Actor Other)
{
    local int i;
    local DH_Pawn P;

    super.Touch(Other);

    P = DH_Pawn(Other);

    //Handle Pawns on Fire!
    if (P != none && P.bOnFire)
    {
        P.bOnFire = false;
        P.bBurnFXOn = false;
        P.bCharred = false;

        if (Level.NetMode != NM_DedicatedServer)
        {
            P.EndBurnFX(); //Stop flame effects on the pawn

            //Leaving charred looks dumb and anyone with that much burn degree wouldn't be able to fight
            //So I remove charred and turn off all overlay materials
            P.SetOverlayMaterial(none, 0.0f, true);
            P.HeadGear.SetOverlayMaterial(none, 0.0f, true);

            //Gotta do it to ammo pouches as well
            for (i = 0; i < P.AmmoPouches.Length; i++)
            {
                P.AmmoPouches[i].SetOverlayMaterial(none, 0.0f, true);
            }
        }
    }

    //Handle projectile effects & splashes
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Other.IsA('ROBallisticProjectile') && !Level.bDropDetail && Level.DetailMode != DM_Low)
        {
            //DH_BulletSplashEffect, DH_50CalSplashEffect, DH_BigExplosiveSplashEffect, and DH_ExplosiveSplashEffect

            if (Other.IsA('ROAntiVehicleProjectile'))
            {
                EntryActor = class'DH_ExplosiveSplashEffect';
                //Testing will have to make new one for sound
                //EntryActor = class'TankHEHitWaterEffect';
                //EntryActor = class'TankAPHitWaterEffect';
                //EntryActor = class'ROArtilleryWaterEmitter';
            }

            if (Other.IsA('ROBullet'))
            {
                //Use this one as final
                EntryActor = class'DH_BulletSplashEffect';

                //Testing
                //EntryActor = class'DH_ExplosiveSplashEffect';
                //EntryActor = class'WaterSplashEmitter';
                //EntryActor = class'ROBulletHitWaterEffect';
                //BulletSplashEmitter
            }

            PlayEntrySplash(Other);
        }
    }
}

defaultproperties
{
    PawnEntryActorName=""
    ExitSoundName=""
    EntrySoundName=""
    EntryActor="DH_BulletSplashEffect"
    bDistanceFog=true
    DistanceFogColor=(R=0,G=0,B=0,A=0)
    DistanceFogStart=0.0
    DistanceFogEnd=64.0
    KExtraLinearDamping=2.5
    KExtraAngularDamping=0.4
}

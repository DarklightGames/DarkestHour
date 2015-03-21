//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ROMountedTankMGPawn extends ROMountedTankMGPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

var     DH_ROMountedTankMG  MGun;             // just a reference to the DH MG actor, for convenience & to avoid lots of casts

var()   int         InitialPositionIndex;     // initial gunner position on entering
var()   int         UnbuttonedPositionIndex;  // lowest position number where player is unbuttoned
var()   bool        bPlayerCollisionBoxMoves; // player's collision box moves with animations (e.g. raised/lowered on unbuttoning/buttoning), so we need to play anims on server
var()   texture     VehicleMGReloadTexture;   // used to show reload progress on the HUD, like a tank cannon reload

var()   name        FirstPersonGunRefBone;      // static gun bone used as reference point to adjust 1st person view HUDOverlay offset, if gunner can raise his head above sights
var()   float       FirstPersonGunOffsetZScale; // used with HUDOverlay to scale how much lower the 1st person gun appears when player raises his head above it

var()   float       OverlayCenterSize;        // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var()   float       OverlayCenterTexStart;
var()   float       OverlayCenterTexSize;
var()   float       OverlayCorrectionX;
var()   float       OverlayCorrectionY;

var     bool        bDebugExitPositions;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits; // only during development
}

// Matt: modified to call InitializeMG when we've received both the replicated Gun & VehicleBase actors (just after vehicle spawns via replication), which has 2 benefits:
// 1. Do things that need one or both of those actor refs, controlling common problem of unpredictability of timing of receiving replicated actor references
// 2. To do any extra set up in the MG classes, which can easily be subclassed for anything that is vehicle specific
simulated function PostNetReceive()
{
    local int i;

    // Gunner has changed position
    if (DriverPositionIndex != SavedPositionIndex && Gun != none && bMultiPosition)
    {
        if (Driver == none && DriverPositionIndex > 0 && !IsLocallyControlled() && Level.NetMode == NM_Client)
        {
            // do nothing
        }
        else
        {
            LastPositionIndex = SavedPositionIndex;
            SavedPositionIndex = DriverPositionIndex;
            NextViewPoint();
        }
    }

    // Initialize the MG (added VehicleBase != none, so we guarantee that VB is available to InitializeMG)
    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeMG();
    }

    // Initialize the vehicle base
    if (!bInitializedVehicleBase && VehicleBase != none)
    {
        bInitializedVehicleBase = true;

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        if (VehicleBase.WeaponPawns.Length > 0 && VehicleBase.WeaponPawns.Length > PositionInArray &&
            (VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none))
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;

            return;
        }

        for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
        {
            if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
            {
                return;
            }
        }

        VehicleBase.WeaponPawns[PositionInArray] = self;
    }

    // Matt: if this is a single position MG & we've initialized the vehicle weapon & vehicle base, we can now switch off PostNetReceive
    if (!bMultiPosition && bInitializedVehicleGun && bInitializedVehicleBase)
    {
        bNetNotify = false;
    }
}

// Modified to call InitializeMG to do any extra set up in the MG classes
// This is where we do it for standalones or servers (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeMG();
    }
}

// Matt: new function to do any extra set up in the MG classes (called from PostNetReceive on net client or from AttachToVehicle on standalone or server)
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMG()
{
    MGun = DH_ROMountedTankMG(Gun);

    if (MGun != none)
    {
        MGun.InitializeMG(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DH_ROMountedTankMG, so lots of things are not going to work!");
    }
}

// Modified to calculate & set texture MGOverlay variables once instead of every DrawHUD
simulated function PostBeginPlay()
{
    local float OverlayCenterScale;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer && MGOverlay != none)
    {
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * Float(MGOverlay.USize) / 2.0;
        OverlayCenterTexSize =  Float(MGOverlay.USize) * OverlayCenterScale;
    }
}

// Modified so that if MG is reloading when player enters, we pass the reload start time (indirectly), so client can calculate reload progress to display on HUD
function KDriverEnter(Pawn P)
{
    local float PercentageOfReloadDone;


    if (MGun != none && MGun.bReloading)
    {
        PercentageOfReloadDone = Byte(100.0 * (Level.TimeSeconds - MGun.ReloadStartTime) / MGun.ReloadDuration);
        MGun.ClientHandleReload(PercentageOfReloadDone);
    }

    super(VehicleWeaponPawn).KDriverEnter(P); // skip over Super in ROMountedTankMGPawn as it sets rotation we now want to avoid
}

// Modified to match rotation to MG's aim (also consolidates & optimises the Supers)
simulated function ClientKDriverEnter(PlayerController PC)
{
    if (bMultiPosition)
    {
        Gotostate('EnteringVehicle');
        PendingPositionIndex = 0;
    }
    else
    {
        PC.SetFOV(WeaponFOV);
    }

    StoredVehicleRotation = VehicleBase.Rotation; // Matt: I don't think this is used anywhere & will probably remove from all functions later

    super(Vehicle).ClientKDriverEnter(PC);

    MatchRotationToGunAim();
}

// Modified so MG retains its aimed direction when player enters & may switch to internal mesh
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        SwitchMesh(0);

        if (Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }

        WeaponFOV = DriverPositions[0].ViewFOV;
        PlayerController(Controller).SetFOV(WeaponFOV);

        FPCamPos = DriverPositions[0].ViewLocation;
    }
}

// Modified to prevent players exiting unless unbuttoned & also so that exit stuff only happens if the Super returns true
function bool KDriverLeave(bool bForceLeave)
{
    if (!bForceLeave && !CanExit()) // bForceLeave means so player is trying to exit not just switch position, so no risk of locking someone in one slot
    {
        return false;
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        DriverPositionIndex = 0;
        LastPositionIndex = 0;

        VehicleBase.MaybeDestroyVehicle();

        return true;
    }

    return false;
}

// Modified so MG retains its aimed direction when player exits & may switch back to external mesh
// Also to remove playing BeginningIdleAnim as now that's played on all net modes in DrivingStatusChanged()
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        SwitchMesh(-1); // -1 signifies switch to default external mesh
    }
}

// Modified to call DriverLeft() because player death doesn't trigger KDriverLeave/DriverLeft/DrivingStatusChanged
function DriverDied()
{
    super.DriverDied();

    DriverLeft(); // fix Unreal bug (as done in ROVehicle), as DriverDied should call DriverLeft, the same as KDriverLeave does
}

// Modified to play idle animation for all net players, so they see closed hatches & any animated collision boxes are re-set (also server if collision is animated)
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving && (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves) && Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
    {
        Gun.PlayAnim(Gun.BeginningIdleAnim);
    }
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int    i, StartIndex;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    if (VehicleBase == none)
    {
        return false;
    }

    // Debug exits - uses abstract class default, allowing bDebugExitPositions to be toggled for all MG pawns
    if (class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions)
    {
        for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer',,, ExitPosition);
        }
    }

    i = Clamp(PositionInArray + 1, 0, VehicleBase.ExitPositions.Length - 1);
    StartIndex = i;

    while (i >= 0 && i < VehicleBase.ExitPositions.Length)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) == none &&
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none &&
            Driver.SetLocation(ExitPosition))
        {
            return true;
        }

        ++i;

        if (i == StartIndex)
        {
            break;
        }
        else if (i == VehicleBase.ExitPositions.Length)
        {
            i = 0;
        }
    }

    return false;
}

// Modified to update custom aim for MGs that use it, but only if the player is actually controlling the MG, i.e. CanFire()
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);

    if (bCustomAiming && CanFire())
    {
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }
    }
}

// Modified to optimise & make into generic function to handle all MG types
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector           CameraLocation, GunOffset, x, y, z;
    local rotator          CameraRotation;
    local Actor            ViewActor;
    local float            SavedOpacity, ScreenRatio;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (!bMultiPosition || (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays)))
        {
            // Draw any HUD overlay
            if (HUDOverlay != none)
            {
                if (!Level.IsSoftwareRendering())
                {
                    CameraRotation = PC.Rotation;
                    SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
                    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);

                    // Make the first person gun appear lower when your sticking your head up
                    if (FirstPersonGunRefBone != '')
                    {
                        GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;
                        GunOffset.Z += (((Gun.GetBoneCoords(FirstPersonGunRefBone).Origin.Z - CameraLocation.Z) * FirstPersonGunOffsetZScale));
                        GunOffset += HUDOverlayOffset;
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        Canvas.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, CameraRotation, PC.ShakeRot * FirstPersonGunShakeScale, GunOffset * -1.0);
                    }
                    else
                    {
                        CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        HUDOverlay.SetRotation(CameraRotation);
                        Canvas.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
                    }
                }
            }
            // Draw gunsight overlay
            else if (MGOverlay != none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = Canvas.ColorModulate.W;
                Canvas.ColorModulate.W = 1.0;
                Canvas.DrawColor.A = 255;
                Canvas.Style = ERenderStyle.STY_Alpha;

                ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
                Canvas.SetPos(0.0, 0.0);

                Canvas.DrawTile(MGOverlay, Canvas.SizeX, Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
                    OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                Canvas.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }
    }
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }
}

// New function, checked by Fire() to see if we are in an eligible firing position (subclass as required)
function bool CanFire()
{
    return true;
}

// Modified to prevent fire based on CanFire() & to add dry-fire effects if trying to fire empty MG
function Fire(optional float F)
{
    if (!CanFire() || Gun == none)
    {
        return;
    }

    if (Gun.ReadyToFire(false))
    {
        VehicleFire(false);
        bWeaponIsFiring = true;

        if (PlayerController(Controller) != none)
        {
            Gun.ClientStartFire(Controller, false);
        }
    }
    else if (MGun != none && !MGun.bReloading)
    {
        Gun.ShakeView(false);
        PlaySound(MGun.NoAmmoSound, SLOT_None, 1.5, , 25.0, , true);
    }
}

// Emptied out as MG has no alt fire mode, so just ensures nothing happens
function AltFire(optional float F)
{
}

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex + 1;
        ServerChangeViewPoint(true);
    }
}

simulated function PrevWeapon()
{
    if (DriverPositionIndex > 0 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex -1;
        ServerChangeViewPoint(false);
    }
}

// Modified so server goes to state ViewTransition when unbuttoning, preventing player exiting until fully unbuttoned
// Server also plays down animation when buttoning up, if player has moving collision box
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
                }
                else if (bPlayerCollisionBoxMoves)
                {
                    AnimateTransition();
                }
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (bPlayerCollisionBoxMoves && Level.NetMode == NM_DedicatedServer) // only if player has moving collision box
            {
                AnimateTransition();
            }
        }
    }
}

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local bool                bMustBeTankerToSwitch;
    local byte                ChosenWeaponPawnIndex;

    if (VehicleBase == none)
    {
        return;
    }

    // Trying to switch to driver position
    if (F == 1)
    {
        // Stop call to server as there is already a human driver
        if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
        {
            return;
        }

        if (VehicleBase.bMustBeTankCommander)
        {
            bMustBeTankerToSwitch = true;
        }
    }
    // Trying to switch to non-driver position
    else
    {
        ChosenWeaponPawnIndex = F - 2;

        // Stop call to server if player has selected an invalid weapon position or the current position
        // Note that if player presses 0, which is invalid choice, the byte index will end up as 254 & so will still fail this test (which is what we want)
        if (ChosenWeaponPawnIndex >= VehicleBase.PassengerWeapons.Length || ChosenWeaponPawnIndex == PositionInArray)
        {
            return;
        }

        // Stop call to server if player selected a rider position but is buttoned up (no 'teleporting' outside to external rider position)
        if (StopExitToRiderPosition(ChosenWeaponPawnIndex))
        {
            return;
        }

        // Get weapon pawn
        if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
        {
            WeaponPawn = ROVehicleWeaponPawn(VehicleBase.WeaponPawns[ChosenWeaponPawnIndex]);
        }

        if (WeaponPawn != none)
        {
            // Stop call to server as weapon position already has a human player
            if (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
            {
                return;
            }

            if (WeaponPawn.bMustBeTankCrew)
            {
                bMustBeTankerToSwitch = true;
            }
        }
        // Stop call to server if weapon pawn doesn't exist, UNLESS PassengerWeapons array lists it as a rider position
        // This is because our new system means rider pawns won't exist on clients unless occupied, so we have to allow this switch through to server
        else if (class<ROPassengerPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none)
        {
            return;
        }
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        DenyEntry(self, 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (StopExitToRiderPosition(F - 2))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // must unbutton the hatch
        }
        else
        {
            if (DH_ROTreadCraft(VehicleBase) != none && DH_ROTreadCraft(VehicleBase).DriverPositions.Length > DH_ROTreadCraft(VehicleBase).UnbuttonedPositionIndex) // means driver has hatch
            {
                ReceiveLocalizedMessage(class'DH_VehicleMessage', 10); // must exit through driver's or commander's hatch
            }
            else
            {
                ReceiveLocalizedMessage(class'DH_VehicleMessage', 5); // must exit through commander's hatch
            }
        }

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    local DH_ROTreadCraft TreadCraft;

    TreadCraft = DH_ROTreadCraft(VehicleBase);

    return TreadCraft != none && TreadCraft.bMustUnbuttonToSwitchToRider && TreadCraft.bAllowRiders &&
        ChosenWeaponPawnIndex >= TreadCraft.FirstRiderPositionIndex && ChosenWeaponPawnIndex < TreadCraft.PassengerWeapons.Length && !CanExit();
}

// New function to handle switching between external & internal mesh, including copying MG's aimed direction to new mesh (just saves code repetition)
simulated function SwitchMesh(int PositionIndex)
{
    local mesh    NewMesh;
    local rotator MGYaw, MGPitch;

    if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && Gun != none)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            if (DriverPositions[PositionIndex].PositionMesh != none)
            {
                NewMesh = DriverPositions[PositionIndex].PositionMesh;
            }
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = Gun.default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Gun.Mesh && NewMesh != none)
        {
            if (bCustomAiming)
            {
                // Save old mesh rotation
                MGYaw.Yaw = VehicleBase.Rotation.Yaw - CustomAim.Yaw;
                MGPitch.Pitch = VehicleBase.Rotation.Pitch - CustomAim.Pitch;

                // Switch to the new mesh
                Gun.LinkMesh(NewMesh);

                // Now make the new mesh you swap to have the same rotation as the old one
                Gun.SetBoneRotation(Gun.YawBone, MGYaw);
                Gun.SetBoneRotation(Gun.PitchBone, MGPitch);
            }
            else
            {
                Gun.LinkMesh(NewMesh);
            }
        }
    }
}

// New function to match rotation to MG's current aim, either relative or independent to vehicle rotation
simulated function MatchRotationToGunAim()
{
    local rotator NewRotation;

    if (Gun != none)
    {
        if (bPCRelativeFPRotation)
        {
            NewRotation = Gun.CurrentAim;
        }
        else
        {
            NewRotation = rotator(vector(Gun.CurrentAim) >> Gun.Rotation); // note Gun.Rotation is effectively same as vehicle base's rotation
        }

        NewRotation.Pitch = LimitPitch(NewRotation.Pitch);

        SetRotation(NewRotation); // note owning net client will update rotation back to server
    }
}

// Modified so if PC's rotation was relative to vehicle (bPCRelativeFPRotation), it gets set to the correct non-relative rotation on exit
// Doing this in a more obvious way here avoids the previous workaround in ClientKDriverLeave, which matched the MG pawn's rotation to the vehicle
simulated function FixPCRotation(PlayerController PC)
{
    PC.SetRotation(rotator(vector(PC.Rotation) >> Gun.Rotation)); // was >> Rotation, i.e. MG pawn's rotation (note Gun.Rotation is effectively same as vehicle base's rotation)
}

// Modified to use new ResupplyAmmo() in the VehicleWeapon classes, instead of GiveInitialAmmo()
function bool ResupplyAmmo()
{
    return MGun != none && MGun.ResupplyAmmo();
}

// New function, used by HUD to show coaxial MG reload progress, like the cannon reload
function float GetAmmoReloadState()
{
    local float ProportionOfReloadRemaining;

    if (MGun != none)
    {
        if (MGun.ReadyToFire(false))
        {
            return 0.0;
        }
        else if (MGun.bReloading)
        {
            ProportionOfReloadRemaining = 1.0 - ((Level.TimeSeconds - MGun.ReloadStartTime) / MGun.ReloadDuration);

            if (ProportionOfReloadRemaining >= 0.75)
            {
                return 1.0;
            }
            else if (ProportionOfReloadRemaining >= 0.5)
            {
                return 0.65;
            }
            else if (ProportionOfReloadRemaining >= 0.25)
            {
                return 0.45;
            }
            else
            {
                return 0.25;
            }
        }
        else
        {
            return 1.0; // must be totally out of ammo, so HUD will draw ammo icon all in red to indicate that MG can't be fired
        }
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) >> Gun.Rotation));
            }

            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = Gun.default.Mesh;
                    DriverPositions[i].ViewFOV = PC.DefaultFOV;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }

                SwitchMesh(DriverPositionIndex);

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }
            else
            {
                PC.SetFOV(PC.DefaultFOV);
                Gun.PitchUpLimit = 65535;
                Gun.PitchDownLimit = 1;
            }

            Gun.bLimitYaw = false;
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bPCRelativeFPRotation)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Gun.Rotation));
        }

        if (bBehindViewChanged)
        {
            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                    DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
                }

                SwitchMesh(DriverPositionIndex);

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
                Gun.PitchUpLimit = Gun.default.PitchUpLimit;
                Gun.PitchDownLimit = Gun.default.PitchDownLimit;
            }

            Gun.bLimitYaw = Gun.default.bLimitYaw;
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller)
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: toggles between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bMultiPosition)
    {
        if (Gun.Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = Gun.default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        SwitchMesh(DriverPositionIndex);
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if (class'DH_LevelInfo'.static.DHDebugMode() && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (Gun.bLimitYaw == Gun.default.bLimitYaw && Gun.PitchUpLimit == Gun.default.PitchUpLimit && Gun.PitchDownLimit == Gun.default.PitchDownLimit)
        {
            Gun.bLimitYaw = false;
            Gun.PitchUpLimit = 65535;
            Gun.PitchDownLimit = 1;

            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].ViewPitchUpLimit = 65535;
                DriverPositions[i].ViewPitchDownLimit = 1;
            }
        }
        else
        {
            Gun.bLimitYaw = Gun.default.bLimitYaw;
            Gun.PitchUpLimit = Gun.default.PitchUpLimit;
            Gun.PitchDownLimit = Gun.default.PitchDownLimit;

            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
            }
        }
    }
}

// Allows debugging exit positions to be toggled for all MG pawns
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions = !class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions;
        Log("DH_ROMountedTankMGPawn.bDebugExitPositions =" @ class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions);
    }
}

defaultproperties
{
    UnbuttonedPositionIndex=1
    OverlayCenterSize=1.0
    MGOverlay=none // to remove default from ROMountedTankMGPawn - set this in subclass if texture sight overlay used
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}

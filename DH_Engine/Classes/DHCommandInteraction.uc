//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This interaction displays configuable radial menus (DHCommandMenu) with up to
// 8 different options.
//==============================================================================

class DHCommandInteraction extends DHInteraction
    dependson(DHCommandMenu);

const FADE_DURATION = 0.25;
const INNER_RADIUS = 16.0;
const OUTER_RADIUS = 32.0;
const TAU = 6.28318530718;

var Stack_Object        Menus;

var float               MenuAlpha;
var Vector              Cursor;
var int                 SelectedIndex;

const MAX_OPTIONS = 8;
const MAX_PROGRESS_SEGMENTS = 8;

// This is necessary because trying to DrawTile on identical TexRotators
// and other procedural materials in the same frame ends up only drawing one
// of them (probably due to engine-level render batching).
var Texture             OptionTextures[MAX_OPTIONS];
var array<TexRotator>   OptionTexRotators;
var TexRotator          ProgressWheelTexRotators[MAX_PROGRESS_SEGMENTS];
var Texture             RingTexture;
var Texture             ProgressSegmentTexture;

var Color               SelectedColor;
var Color               DisabledColor;
var Color               SubmenuColor;

var DHGameReplicationInfo GRI;

var bool                bShouldHideOnLeftMouseRelease;

var Pawn                InstigatorPawn;

var Sound               SelectSound;
var Sound               HoverSound;
var Sound               CancelSound;

var Material            CrosshairMaterial;

var bool                bDebugCursor;

var bool                bIsHolding;         // Whether or not the player is holding the button to select the option.
var float               HoldTimeStart;      // When the button was first pressed.
var float               HoldTimeEnd;        // When the hold time ends.
var Vector              HoldHitLocation;    // The location of the hit when the button was held.
var Vector              HoldHitNormal;      // The normal of the hit when the button was held.

delegate                OnHidden();

event Initialized()
{
    super.Initialized();

    Menus = new class'Stack_Object';

    GRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
    InstigatorPawn = ViewportOwner.Actor.Pawn;

    GotoState('FadeIn');
}

function Hide()
{
    GotoState('FadeOut');
}

function bool IsHiding()
{
    return IsInState('FadeOut');
}

// Programmatically create the materials used for each option.
function CreateOptionTexRotators(DHCommandMenu Menu)
{
    local int i;
    local TexRotator TR;

    if (Menu == none)
    {
        return;
    }

    OptionTexRotators.Length = 0;

    if (Menu.Options.Length <= 0 || Menu.Options.Length > MAX_OPTIONS)
    {
        return;
    }

    for (i = 0; i < Menu.Options.Length; ++i)
    {
        TR = new class'Engine.TexRotator';
        TR.Rotation.Yaw = -(i * (65536 / Menu.SlotCount)) + ((0.5 / Menu.SlotCount) * 65536);
        TR.Material = OptionTextures[Menu.SlotCount - 1];
        TR.TexRotationType = TR_FixedRotation;
        TR.UOffset = TR.Material.MaterialUSize() / 2;
        TR.VOffset = TR.Material.MaterialVSize() / 2;

        OptionTexRotators[OptionTexRotators.Length] = TR;
    }
}

function CreateProgressWheelMaterials()
{
    local int i;
    local TexRotator TR;

    for (i = 0; i < MAX_PROGRESS_SEGMENTS; ++i)
    {
        TR = new class'Engine.TexRotator';
        TR.Rotation.Yaw = -(i * (65536 / MAX_PROGRESS_SEGMENTS)) + ((0.5 / MAX_PROGRESS_SEGMENTS) * 65536);
        TR.Material = ProgressSegmentTexture;
        TR.TexRotationType = TR_FixedRotation;
        TR.UOffset = TR.Material.MaterialUSize() / 2;
        TR.VOffset = TR.Material.MaterialVSize() / 2;

        ProgressWheelTexRotators[i] = TR;
    }
}

// Pushes a new menu onto the top of the stack to be displayed immediately.
// Allows the specification of an optional object to attach to the menu.
function DHCommandMenu PushMenu(string ClassName, optional Object OptionalObject, optional int OptionalInteger)
{
    local DHCommandMenu Menu, OldMenu;
    local class<DHCommandMenu> MenuClass;

    MenuClass = class<DHCommandMenu>(DynamicLoadObject(ClassName, class'class'));

    Menu = new MenuClass;

    if (Menu == none)
    {
        Warn("Failed to load menu class" @ ClassName);

        return none;
    }

    Menu.Interaction = self;
    Menu.MenuObject = OptionalObject;
    Menu.Setup();

    OldMenu = DHCommandMenu(Menus.Peek());

    if (OldMenu != none)
    {
        OldMenu.OnPassive();
    }

    CreateOptionTexRotators(Menu);
    CreateProgressWheelMaterials();

    Menus.Push(Menu);
    Menu.OnPush();
    Menu.OnActive();

    Cursor = vect(0, 0, 0);

    return Menu;
}

// Pops the top menu off of the stack.
function DHCommandMenu PopMenu()
{
    local DHCommandMenu Menu, NewMenu;

    Menu = DHCommandMenu(Menus.Pop());

    if (Menu != none)
    {
        Menu.OnPop();
    }

    NewMenu = DHCommandMenu(Menus.Peek());

    if (NewMenu != none)
    {
        CreateOptionTexRotators(NewMenu);

        NewMenu.OnActive();
    }

    Cursor = vect(0, 0, 0);

    return Menu;
}

auto state FadeIn
{
    function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);

        MenuAlpha = FMin(1.0, MenuAlpha + (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 1.0)
        {
            GotoState('Active');
        }
    }

    event BeginState()
    {
        MenuAlpha = 0.0;
    }
}

state Active
{
    event BeginState()
    {
        MenuAlpha = 1.0;
    }
}

state FadeOut
{
    function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        MenuAlpha = FMax(0.0, MenuAlpha - (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 0.0)
        {
            TearDown();
        }
    }

    function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
    {
        return false;
    }
}

function TearDown()
{
    while (!Menus.IsEmpty())
    {
        PopMenu();
    }

    ViewportOwner.InteractionMaster.RemoveInteraction(self);

    OnHidden();
}

function Tick(float DeltaTime)
{
    local float ArcLength, Theta;
    local DHCommandMenu Menu;
    local DHPlayer PC;
    local int OldSelectedIndex;

    PC = DHPlayer(ViewportOwner.Actor);

    Menu = DHCommandMenu(Menus.Peek());

    if (PC == none || PC.Pawn == none || PC.IsDead() || Menu == none || Menu.ShouldHideMenu() || PC.Pawn != InstigatorPawn)
    {
        Hide();
        return;
    }

    if (Menu.bShouldTick)
    {
        Menu.Tick();
    }

    // Clamp cursor
    Cursor = class'UCore'.static.VClampSize(Cursor, 0.0, OUTER_RADIUS);

    OldSelectedIndex = SelectedIndex;

    if (Menu.Options.Length > 0 && Cursor != vect(0, 0, 0))
    {
        // Calculated the selected index
        ArcLength = TAU / Menu.SlotCount;
        Theta = Atan(Cursor.Y, Cursor.X) + (ArcLength / 2);
        Theta += class'UUnits'.static.DegreesToRadians(90);

        if (Theta < 0)
        {
            Theta = TAU + Theta;
        }

        if (VSize(Cursor) < INNER_RADIUS)
        {
            // No selection
            SelectedIndex = -1;
        }
        else
        {
            SelectedIndex = Menu.GetOptionIndexFromSlotIndex(Menu.SlotCount * (Theta / TAU));
        }
    }
    else
    {
        SelectedIndex = -1;
    }

    if (OldSelectedIndex != SelectedIndex)
    {
        if (OldSelectedIndex != -1)
        {
            Menu.OnHoverOut(OldSelectedIndex);
        }

        if (SelectedIndex != -1 && !Menu.IsOptionDisabled(SelectedIndex))
        {
            PlaySound(HoverSound);

            Menu.OnHoverIn(SelectedIndex);
        }
    }

    if (bIsHolding)
    {
        if (!CanSelectOption(SelectedIndex))
        {
            // The option is now disabled, so stop holding.
            bIsHolding = false;
        }
        else
        {
            if (HoldTimeEnd - ViewportOwner.Actor.Level.TimeSeconds <= 0.0)
            {
                // Perform the action.
                bIsHolding = false;
                OnSelect(SelectedIndex, HoldHitLocation, HoldHitNormal);
            }
        }
    }
}

function DrawCenteredTile(Canvas C, Material TileMaterial, float CenterX, float CenterY, float GUIScale)
{
    local float MaterialUSize, MaterialVSize;
    local float USize, VSize;

    MaterialUSize = TileMaterial.MaterialUSize();
    MaterialVSize = TileMaterial.MaterialVSize();

    USize = GUIScale * MaterialUSize;
    VSize = GUIScale * MaterialVSize;

    C.SetPos(CenterX - (USize / 2), CenterY - (VSize / 2));
    C.DrawTile(TileMaterial, USize, VSize, 0, 0, MaterialUSize, MaterialVSize);
}

function PostRender(Canvas C)
{
    local int i, OptionIndex;
    local float Theta, ArcLength;
    local float CenterX, CenterY, X, Y, XL, YL, AspectRatio, XL2, YL2, GUIScale;
    local DHCommandMenu Menu;
    local bool bIsOptionDisabled;
    local DHCommandMenu.OptionRenderInfo ORI;
    local float HoldProgressTheta;

    if (C == none)
    {
        return;
    }

    // Calculate the GUI scale factor as compared to 1080p.
    GUIScale = C.ClipY / 1080.0;
    CenterX = C.ClipX / 2;
    CenterY = C.ClipY / 2;

    C.DrawColor = class'UColor'.default.White;
    C.DrawColor.A = byte(255 * MenuAlpha);

    // Draw menu crosshair
    DrawCenteredTile(C, CrosshairMaterial, CenterX, CenterY, GUIScale);

    // Draw outer "beauty" ring
    DrawCenteredTile(C, RingTexture, CenterX, CenterY, GUIScale);

    C.Font = class'DHHud'.static.GetSmallerMenuFont(C);

    Menu = DHCommandMenu(Menus.Peek());

    Theta -= class'UUnits'.static.DegreesToRadians(90);

    if (Menu == none)
    {
        return;
    }

    ArcLength = TAU / Menu.SlotCount;

    // Draw all the options.
    for (i = 0; i < Menu.SlotCount; ++i)
    {
        OptionIndex = Menu.GetOptionIndexFromSlotIndex(i);

        if (OptionIndex == -1)
        {
            continue;
        }

        bIsOptionDisabled = Menu.IsOptionDisabled(OptionIndex);

        if (bIsOptionDisabled)
        {
            C.DrawColor = default.DisabledColor;

            if (SelectedIndex == OptionIndex)
            {
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.9));
            }
            else
            {
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.5));
            }
        }
        else
        {
            if (SelectedIndex == OptionIndex)
            {
                C.DrawColor = default.SelectedColor;
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.9));
            }
            else
            {
                C.DrawColor = class'UColor'.default.White;
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.5));
            }
        }

        // Draw the option background texture.
        DrawCenteredTile(C, OptionTexRotators[i], CenterX, CenterY, GUIScale);

        // Draw option icon
        if (Menu.Options[OptionIndex].Material != none)
        {
            if (bIsOptionDisabled)
            {
                C.DrawColor = class'UColor'.default.DarkGray;
            }
            else
            {
                if (class'UColor'.static.IsZero(Menu.Options[OptionIndex].IconColor))
                {
                    C.DrawColor = class'UColor'.default.White;
                }
                else
                {
                    C.DrawColor = Menu.Options[OptionIndex].IconColor;
                }
            }

            C.DrawColor.A = byte(255 * MenuAlpha);

            // Calculate the center of where the option icon should be.
            X = CenterX + (Cos(Theta) * (GUIScale * 144.0));
            Y = CenterY + (Sin(Theta) * (GUIScale * 144.0));

            DrawCenteredTile(C, Menu.Options[OptionIndex].Material, X, Y, GUIScale);
        }

        Theta += ArcLength;
    }

    // Display text of selection.
    if (SelectedIndex >= 0)
    {
        Menu.GetOptionRenderInfo(SelectedIndex, ORI);

        // Draw info text
        for (i = 0; i < arraycount(ORI.InfoText); ++i)
        {
            if (ORI.InfoText[i] != "")
            {
                C.TextSize(ORI.InfoText[i], XL, YL);
                C.DrawColor = ORI.InfoColor;
                C.DrawColor.A = byte(255 * MenuAlpha);
                C.SetPos(CenterX - (XL / 2), CenterY - (GUIScale * 32) - (i + 1) * YL);
                C.DrawText(ORI.InfoText[i]);

                if (i == 0)
                {
                    // Draw action icon
                    if (ORI.InfoIcon != none)
                    {
                        AspectRatio = ORI.InfoIcon.MaterialUSize() / ORI.InfoIcon.MaterialVSize();

                        YL2 = 32;
                        XL2 = YL2 * AspectRatio;

                        YL2 *= GUIScale;
                        XL2 *= GUIScale;

                        C.DrawColor = ORI.InfoColor;
                        C.DrawColor.A = byte(255 * MenuAlpha);
                        C.SetPos(CenterX - (XL / 2) - XL2 - (GUIScale * 4), CenterY - YL2 - YL - (GUIScale * 8));
                        C.DrawTile(ORI.InfoIcon, XL2, YL2, 0, 0, ORI.InfoIcon.MaterialUSize() - 1, ORI.InfoIcon.MaterialVSize() - 1);
                    }
                }
            }
        }

        // Draw action text
        C.TextSize(ORI.OptionName, XL, YL);
        C.DrawColor = class'UColor'.default.White;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2), CenterY + (GUIScale * 32.0));
        C.DrawText(ORI.OptionName);

        // Draw description text
        C.TextSize(ORI.DescriptionText, XL, YL);
        C.DrawColor = class'UColor'.default.White;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2), CenterY - (GUIScale * 192) - YL);
        C.DrawText(ORI.DescriptionText);
    }

    // Display hold time progress bar, if holding.
    if (bIsHolding)
    {
        HoldProgressTheta = class'UInterp'.static.MapRangeClamped(
            ViewportOwner.Actor.Level.TimeSeconds, 
            HoldTimeStart,
            HoldTimeEnd,
            0.0,
            1.0);
        
        // Use a deceleration interpolation so that the user can see that progress is being made immediately.
        HoldProgressTheta = class'UInterp'.static.Interpolate(
            HoldProgressTheta,
            0.0,
            1.0,
            INTERP_Deceleration
            ) * MAX_PROGRESS_SEGMENTS;

        for (i = 0; i < MAX_PROGRESS_SEGMENTS; ++i)
        {
            Theta = class'UInterp'.static.MapRangeClamped(HoldProgressTheta, i, i + 1.0, 0.0, 1.0);

            C.DrawColor = class'UColor'.static.Interp(Theta, class'UColor'.default.White, SelectedColor);
            C.DrawColor.A = byte(255 * MenuAlpha * Theta);

            DrawCenteredTile(C, ProgressWheelTexRotators[i], CenterX, CenterY, GUIScale);
        }
    }
    
    if (bDebugCursor)
    {
        // Draw the cursor position for debugging purposes.
        C.SetPos(CenterX + Cursor.X, CenterY + Cursor.Y);
        C.DrawColor = class'UColor'.default.Red;
        C.DrawBox(C, 4, 4);
    }
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local vector HitLocation, HitNormal;
    local DHCommandMenu Menu;
    local Sound HoldSound;
    
    Menu = DHCommandMenu(Menus.Peek());

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none || PC.Pawn == none && PC.Pawn.Region.Zone != none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    switch (Action)
    {
        case IST_Axis:
            if (!bIsHolding)
            {
                switch (Key)
                {
                    case IK_MouseX:
                        Cursor.X += Delta;
                        return true;
                    case IK_MouseY:
                        Cursor.Y -= Delta;
                        return true;
                    default:
                        break;
                }
            }
            break;
        case IST_Release:
            switch (Key)
            {
                case IK_LeftMouse:
                    if (bIsHolding)
                    {
                        bIsHolding = false;
                        return true;
                    }

                    if (bShouldHideOnLeftMouseRelease)
                    {
                        if (SelectedIndex >= 0)
                        {
                            PC.GetEyeTraceLocation(HitLocation, HitNormal);
                            OnSelect(SelectedIndex, HitLocation, HitNormal);
                        }

                        Hide();

                        return false;
                    }
                    break;
            }
            break;
        case IST_Press:
            switch (Key)
            {
                // TODO: Left mouse might not be bound to fire, and exec functions
                // do not register in interactions. This isn't ideal, but I'm
                // guessing that 99.9% of players use left mouse as the fire
                // key, so this will do for now.
                case IK_LeftMouse:
                    PC.GetEyeTraceLocation(HitLocation, HitNormal);

                    if (Menu != none && Menu.GetOptionHoldTime(SelectedIndex) > 0.0 && !Menu.IsOptionDisabled(SelectedIndex))
                    {
                        bIsHolding = true;
                        HoldTimeStart = ViewportOwner.Actor.Level.TimeSeconds;
                        HoldTimeEnd = HoldTimeStart + Menu.GetOptionHoldTime(SelectedIndex);
                        HoldHitLocation = HitLocation;
                        HoldHitNormal = HitNormal;

                        HoldSound = Menu.GetOptionHoldSound(SelectedIndex);

                        if (HoldSound != none)
                        {
                            PlaySound(HoldSound);
                        }
                    }
                    else
                    {
                        OnSelect(SelectedIndex, HitLocation, HitNormal);
                    }

                    return true;
                case IK_RightMouse:
                    PlaySound(CancelSound);
                    PopMenu();
                    return true;
                default:
                    break;
            }
            return false;
        default:
            break;
    }

    return false;
}

function bool CanSelectOption(int OptionIndex)
{
    local DHCommandMenu Menu;

    Menu = DHCommandMenu(Menus.Peek());

    return Menu != none && OptionIndex >= 0 && OptionIndex < Menu.Options.Length && !Menu.IsOptionDisabled(OptionIndex);
}

function OnSelect(int OptionIndex, optional vector Location, optional vector HitNormal)
{
    local DHCommandMenu Menu;

    if (!CanSelectOption(OptionIndex))
    {
        return;
    }

    Menu = DHCommandMenu(Menus.Peek());

    if (Menu == none)
    {
        return;
    }

    Menu.OnSelect(OptionIndex, Location, HitNormal);

    PlaySound(SelectSound);
}

function PlaySound(Sound Sound)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none && PC.Pawn != none)
    {
        PC.Pawn.PlayOwnedSound(Sound, SLOT_Interface, 1.0);
    }
}

function bool IsFadingIn() { return IsInState('FadeIn'); }
function bool IsFadingOut() { return IsInState('FadeOut'); }
function bool IsFadingInOrOut() { return IsFadingIn() || IsFadingOut(); }

defaultproperties
{
    bActive=true
    bVisible=true
    bRequiresTick=true

    OptionTextures(0)=Texture'DH_InterfaceArt_tex.menu_option_1'
    OptionTextures(1)=Texture'DH_InterfaceArt_tex.menu_option_2'
    OptionTextures(2)=Texture'DH_InterfaceArt_tex.menu_option_3'
    OptionTextures(3)=Texture'DH_InterfaceArt_tex.menu_option_4'
    OptionTextures(4)=Texture'DH_InterfaceArt_tex.menu_option_5'
    OptionTextures(5)=Texture'DH_InterfaceArt_tex.menu_option_6'
    OptionTextures(6)=Texture'DH_InterfaceArt_tex.menu_option_7'
    OptionTextures(7)=Texture'DH_InterfaceArt_tex.menu_option_8'

    RingTexture=Texture'DH_InterfaceArt_tex.ring'
    ProgressSegmentTexture=Texture'DH_InterfaceArt_tex.menu_progress_segment'

    SelectedColor=(R=255,G=255,B=64,A=255)
    DisabledColor=(R=32,G=32,B=32,A=255)
    SubmenuColor=(R=255,G=64,B=255,A=255)

    SelectSound=Sound'ROMenuSounds.msfxMouseClick'
    HoverSound=Sound'ROMenuSounds.msfxDown'
    CancelSound=Sound'ROMenuSounds.CharFade'

    CrosshairMaterial=Material'DH_InterfaceArt_tex.menu_crosshair'
}

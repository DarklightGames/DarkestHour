//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

// This is necessary because trying to DrawTile on identical TexRotators
// and other procedural materials in the same frame ends up only drawing one
// of them (probably due to engine-level render batching).
var Texture             OptionTextures[MAX_OPTIONS];
var array<TexRotator>   OptionTexRotators;
var Texture             RingTexture;

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
}

function DrawCenteredTile(Canvas C, Material TileMaterial, float CenterX, float CenterY)
{
    local float USize, VSize;

    USize = TileMaterial.MaterialUSize();
    VSize = TileMaterial.MaterialVSize();

    C.SetPos(CenterX - (USize / 2), CenterY - (VSize / 2));
    C.DrawTile(TileMaterial, USize, VSize, 0, 0, USize, VSize);
}

function PostRender(Canvas C)
{
    local int i, OptionIndex;
    local float Theta, ArcLength;
    local float CenterX, CenterY, X, Y, XL, YL, U, V, AspectRatio, XL2, YL2;
    local DHCommandMenu Menu;
    local bool bIsOptionDisabled;
    local DHCommandMenu.OptionRenderInfo ORI;

    if (C == none)
    {
        return;
    }

    CenterX = C.ClipX / 2;
    CenterY = C.ClipY / 2;

    C.DrawColor = class'UColor'.default.White;
    C.DrawColor.A = byte(255 * MenuAlpha);

    // Draw menu crosshair
    DrawCenteredTile(C, CrosshairMaterial, CenterX, CenterY);

    // Draw outer "beauty" ring
    DrawCenteredTile(C, RingTexture, CenterX, CenterY);

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
                C.DrawColor.A = byte(255 * MenuAlpha);
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
        DrawCenteredTile(C, OptionTexRotators[i], CenterX, CenterY);

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
            X = CenterX + (Cos(Theta) * 144);
            Y = CenterY + (Sin(Theta) * 144);

            DrawCenteredTile(C, Menu.Options[OptionIndex].Material, X, Y);
        }

        Theta += ArcLength;
    }

    // Display text of selection
    if (SelectedIndex >= 0)
    {
        Menu.GetOptionRenderInfo(SelectedIndex, ORI);

        // Draw action text
        C.TextSize(ORI.OptionName, XL, YL);
        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2) + 1, CenterY + 33);
        C.DrawText(ORI.OptionName);
        C.DrawColor = class'UColor'.default.White;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2), CenterY + 32);
        C.DrawText(ORI.OptionName);

        // Draw info text
        for (i = 0; i < arraycount(ORI.InfoText); ++i)
        {
            if (ORI.InfoText[i] != "")
            {
                C.TextSize(ORI.InfoText[i], XL, YL);
                C.DrawColor = class'UColor'.default.Black;
                C.DrawColor.A = byte(255 * MenuAlpha);
                C.SetPos(CenterX - (XL / 2) + 1, CenterY - 31 -  (i + 1) * YL);
                C.DrawText(ORI.InfoText[i]);
                C.DrawColor = ORI.InfoColor;
                C.DrawColor.A = byte(255 * MenuAlpha);
                C.SetPos(CenterX - (XL / 2), CenterY - 32 - (i + 1) * YL);
                C.DrawText(ORI.InfoText[i]);
            }
        }

        // Draw action icon
        if (ORI.InfoIcon != none)
        {
            AspectRatio = ORI.InfoIcon.MaterialUSize() / ORI.InfoIcon.MaterialVSize();

            YL2 = 32;
            XL2 = YL2 * AspectRatio;

            C.DrawColor = ORI.InfoColor;
            C.DrawColor.A = byte(255 * MenuAlpha);
            C.SetPos(CenterX - (XL / 2) - XL2, CenterY - YL2 - YL - 8);
            C.DrawTile(ORI.InfoIcon, XL2, YL2, 0, 0, ORI.InfoIcon.MaterialUSize() - 1, ORI.InfoIcon.MaterialVSize() - 1);
        }

        // Draw description text
        C.TextSize(ORI.DescriptionText, XL, YL);
        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2) + 1, CenterY - 192 -  YL);
        C.DrawText(ORI.DescriptionText);
        C.DrawColor = class'UColor'.default.White;
        C.DrawColor.A = byte(255 * MenuAlpha);
        C.SetPos(CenterX - (XL / 2), CenterY - 192 - YL);
        C.DrawText(ORI.DescriptionText);
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
            break;
        case IST_Release:
            switch (Key)
            {
                case IK_LeftMouse:
                    if (bShouldHideOnLeftMouseRelease)
                    {
                        if (SelectedIndex >= 0)
                        {
                            PC.GetEyeTraceLocation(HitLocation, HitNormal);
                            OnSelect(SelectedIndex, HitLocation);
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
                    OnSelect(SelectedIndex, HitLocation);

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

function OnSelect(int OptionIndex, optional vector Location)
{
    local DHCommandMenu Menu;

    Menu = DHCommandMenu(Menus.Peek());

    if (Menu == none || OptionIndex < 0 || OptionIndex >= Menu.Options.Length || Menu.IsOptionDisabled(OptionIndex))
    {
        return;
    }

    Menu.OnSelect(OptionIndex, Location);

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

    OptionTextures(0)=Texture'DH_InterfaceArt_tex.Communication.menu_option_1'
    OptionTextures(1)=Texture'DH_InterfaceArt_tex.Communication.menu_option_2'
    OptionTextures(2)=Texture'DH_InterfaceArt_tex.Communication.menu_option_3'
    OptionTextures(3)=Texture'DH_InterfaceArt_tex.Communication.menu_option_4'
    OptionTextures(4)=Texture'DH_InterfaceArt_tex.Communication.menu_option_5'
    OptionTextures(5)=Texture'DH_InterfaceArt_tex.Communication.menu_option_6'
    OptionTextures(6)=Texture'DH_InterfaceArt_tex.Communication.menu_option_7'
    OptionTextures(7)=Texture'DH_InterfaceArt_tex.Communication.menu_option_8'

    RingTexture=Texture'DH_InterfaceArt_tex.Communication.ring'

    SelectedColor=(R=255,G=255,B=64,A=255)
    DisabledColor=(R=32,G=32,B=32,A=255)
    SubmenuColor=(R=255,G=64,B=255,A=255)

    SelectSound=Sound'ROMenuSounds.msfxMouseClick'
    HoverSound=Sound'ROMenuSounds.msfxDown'
    CancelSound=Sound'ROMenuSounds.CharFade'

    CrosshairMaterial=Material'DH_InterfaceArt_tex.Communication.menu_crosshair'
}

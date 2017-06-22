//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================
// This interaction displays configuable radial menus (DHCommandMenu) with up to
// 8 different options.
//==============================================================================

class DHCommandInteraction extends DHInteraction;

const FADE_DURATION = 0.25;
const INNER_RADIUS = 16.0;
const OUTER_RADIUS = 32.0;
const Tau = 6.28318530718;

var Stack_Object        Menus;

var float               MenuAlpha;
var vector              Cursor;
var int                 SelectedIndex;

const MAX_OPTIONS = 8;

// This is necessary because trying to DrawTile on identical TexRotators
// and other procedural materials in the same frame ends up only drawing one
// of them (probably due to engine-level render batching).
var Texture             OptionTextures[MAX_OPTIONS];
var array<TexRotator>   OptionTexRotators;

var color               SelectedColor;
var color               DisabledColor;
var color               SubmenuColor;

event Initialized()
{
    super.Initialized();

    Menus = new class'Stack_Object';

    GotoState('FadeIn');
}

function Hide()
{
    GotoState('FadeOut');
}

// Programmatically create the materials used for each option.
function CreateOptionTexRotators(int OptionCount)
{
    local int i;
    local TexRotator TR;
    local TexOscillator TO;
    local float Angle;
    local float Amplitude;

    OptionTexRotators.Length = 0;

    if (OptionCount <= 0 || OptionCount > MAX_OPTIONS)
    {
        Warn("Assertion error, option count must be between 1 and" @ MAX_OPTIONS @ "(found" @ OptionCount $ ")");
        return;
    }

    Amplitude = 0.01;
    Angle = (0.5 / OptionCount) * Tau;

    for (i = 0; i < OptionCount; ++i)
    {
        TO = new class'Engine.TexOscillator';
        TO.Material = OptionTextures[OptionCount - 1];
        TO.UOscillationAmplitude = Sin(Angle) * Amplitude;
        TO.UOscillationRate = 0.0;
        TO.UOscillationPhase = 0.5;
        TO.VOscillationAmplitude = Cos(Angle) * -Amplitude;
        TO.VOscillationRate = 0.0;
        TO.VOscillationPhase = 0.5;

        TR = new class'Engine.TexRotator';
        TR.Material = TO;
        TR.TexRotationType = TR_FixedRotation;
        TR.UOffset = TR.Material.MaterialUSize() / 2;
        TR.VOffset = TR.Material.MaterialVSize() / 2;

        TR.Rotation.Yaw = -(i * (65536 / OptionCount)) + ((0.5 / OptionCount) * 65536);

        OptionTexRotators[OptionTexRotators.Length] = TR;
    }
}

// Pushes a new menu onto the top of the stack to be displayed immediately.
// Allows the specification of an optional object to attach to the menu.
function DHCommandMenu PushMenu(string ClassName, optional Object OptionalObject)
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

    CreateOptionTexRotators(Menu.Options.Length);

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
        CreateOptionTexRotators(NewMenu.Options.Length);

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
            while (!Menus.IsEmpty())
            {
                PopMenu();
            }

            ViewportOwner.InteractionMaster.RemoveInteraction(self);
        }
    }

    function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
    {
        return false;
    }
}

function Tick(float DeltaTime)
{
    local float ArcLength, Theta;
    local DHCommandMenu Menu;
    local DHPlayer PC;
    local int OldSelectedIndex;

    PC = DHPlayer(ViewportOwner.Actor);

    Menu = DHCommandMenu(Menus.Peek());

    if (PC == none || PC.Pawn == none || PC.IsDead() || Menu == none || Menu.ShouldHideMenu())
    {
        Hide();
        return;
    }

    // Clamp cursor
    Cursor = class'UCore'.static.VClampSize(Cursor, 0.0, OUTER_RADIUS);

    OldSelectedIndex = SelectedIndex;

    if (Menu.Options.Length > 0 && Cursor != vect(0, 0, 0))
    {
        // Calculated the selected index
        ArcLength = Tau / Menu.Options.Length;
        Theta = Atan(Cursor.Y, Cursor.X) + (ArcLength / 2);
        Theta += class'UUnits'.static.DegreesToRadians(90);

        if (Theta < 0)
        {
            Theta = Tau + Theta;
        }

        if (VSize(Cursor) < INNER_RADIUS)
        {
            // No selection
            SelectedIndex = -1;
        }
        else
        {
            SelectedIndex = (Menu.Options.Length * (Theta / Tau));
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
            PC.Pawn.PlayOwnedSound(sound'ROMenuSounds.msfxDown', SLOT_Interface, 1.0);

            Menu.OnHoverIn(SelectedIndex);
        }
    }
}

function PostRender(Canvas C)
{
    local int i;
    local float Theta, ArcLength;
    local float CenterX, CenterY, X, Y, XL, YL, U, V;
    local DHCommandMenu Menu;
    local string ActionText, SubjectText;
    local bool bIsOptionDisabled;
    local color TextColor;

    if (C == none)
    {
        return;
    }

    CenterX = (C.ClipX / 2);
    CenterY = (C.ClipY / 2);

    // TODO: get rid of magic numbers
    C.SetPos(CenterX - 8, CenterY - 8);

    // Draw menu crosshair
    C.DrawColor = class'UColor'.default.White;
    C.DrawTile(material'DH_InterfaceArt_tex.Communication.menu_crosshair', 16, 16, 0, 0, 16, 16);

    C.Font = class'DHHud'.static.GetSmallerMenuFont(C);

    Menu = DHCommandMenu(Menus.Peek());

    Theta -= class'UUnits'.static.DegreesToRadians(90);

    if (Menu != none)
    {
        ArcLength = Tau / Menu.Options.Length;

        // Draw all the options.
        for (i = 0; i < Menu.Options.Length; ++i)
        {
            bIsOptionDisabled = Menu.IsOptionDisabled(i);

            if (bIsOptionDisabled)
            {
                C.DrawColor = default.DisabledColor;

                if (SelectedIndex == i)
                {
                    C.DrawColor.A = byte(255 * (MenuAlpha));
                }
                else
                {
                    C.DrawColor.A = byte(255 * (MenuAlpha * 0.5));
                }
            }
            else
            {
                if (SelectedIndex == i)
                {
                    // TODO: also do some sort of "push out" with some sort of offset thing?

                    C.DrawColor = default.SelectedColor;
                    C.DrawColor.A = byte(255 * (MenuAlpha * 0.9));
                }
                else
                {
                    switch (Menu.Options[i].Type)
                    {
                        case TYPE_Normal:
                            C.DrawColor = class'UColor'.default.White;
                            break;
                        case TYPE_Submenu:
                            C.DrawColor = default.SubmenuColor;
                            break;
                    }

                    C.DrawColor.A = byte(255 * (MenuAlpha * 0.5));
                }
            }

            if (SelectedIndex == i)
            {
                // indent the position just slightly
                //(0.5 / MenuOptions.Length)
            }

            C.SetPos(CenterX - 256, CenterY - 256);
            C.DrawTileClipped(OptionTexRotators[i], 512, 512, 0, 0, 512, 512);

            // Draw option icon
            if (Menu.Options[i].Material != none)
            {
                U = Menu.Options[i].Material.MaterialUSize();
                V = Menu.Options[i].Material.MaterialVSize();

                X = CenterX  + (Cos(Theta) * 144) - (U / 2);
                Y = CenterY + (Sin(Theta) * 144) - (V / 2);

                if (bIsOptionDisabled)
                {
                    C.DrawColor = DisabledColor;

                    if (SelectedIndex == i)
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
                    C.DrawColor = class'UColor'.default.White;
                    C.DrawColor.A = byte(255 * MenuAlpha);
                }

                C.SetPos(X, Y);
                C.DrawTileClipped(Menu.Options[i].Material, U, V, 0, 0, U, V);
            }

            Theta += ArcLength;
        }
    }

    // Display text of selection
    if (SelectedIndex >= 0)
    {
        Menu.GetOptionText(SelectedIndex, ActionText, SubjectText, TextColor);

        C.TextSize(ActionText, XL, YL);

        // Draw action text
        C.DrawColor = class'UColor'.default.Black;
        C.SetPos(CenterX - (XL / 2) + 1, CenterY + 33);
        C.DrawText(ActionText);
        C.DrawColor = class'UColor'.default.White;
        C.SetPos(CenterX - (XL / 2), CenterY + 32);
        C.DrawText(ActionText);

        // Draw subject text
        C.TextSize(SubjectText, XL, YL);
        C.DrawColor = class'UColor'.default.Black;
        C.SetPos(CenterX - (XL / 2) + 1, CenterY - 31 -  YL);
        C.DrawText(SubjectText);
        C.DrawColor = TextColor;
        C.SetPos(CenterX - (XL / 2), CenterY - 32 - YL);
        C.DrawText(SubjectText);

        // Draw action icon
        if (Menu.Options[SelectedIndex].ActionIcon != none)
        {
            C.DrawColor = TextColor;
            C.SetPos(CenterX - (XL / 2) - 32, CenterY - 32 - YL - 8);
            C.DrawTile(Menu.Options[SelectedIndex].ActionIcon, 32, 32, 0, 0, 31, 31);
        }
    }

//    // debug rendering for cursor
//    C.SetPos(CenterX + Cursor.X, CenterY + Cursor.Y);
//    C.DrawColor = class'UColor'.default.Red;
//    C.DrawBox(C, 4, 4);
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;
    local Actor A, HitActor;

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
        case IST_Press:
            switch (Key)
            {
                // TODO: Left mouse might not be bound to fire, and exec functions
                // do not register in interactions. This isn't ideal, but I'm
                // guessing that %99.9 of players use left mouse as the fire
                // key, so this will do for now.
                case IK_LeftMouse:
                    TraceStart = PC.CalcViewLocation;
                    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * PC.Pawn.Region.Zone.DistanceFogEnd);

                    foreach PC.TraceActors(class'Actor', A, HitLocation, HitNormal, TraceEnd, TraceStart)
                    {
                        if (A == PC.Pawn ||
                            A.IsA('ROBulletWhipAttachment') ||
                            A.IsA('Volume'))
                        {
                            continue;
                        }

                        HitActor = A;

                        break;
                    }

                    Log(HitActor);

                    if (HitActor == none)
                    {
                        HitLocation = TraceEnd;
                    }

                    OnSelect(SelectedIndex, HitLocation);

                    return true;
                case IK_RightMouse:
                    if (Menus.Size() > 1)
                    {
                        PopMenu();
                    }
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
}

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

    SelectedColor=(R=255,G=255,B=64,A=255)
    DisabledColor=(R=32,G=32,B=32,A=255)
    SubmenuColor=(R=255,G=64,B=255,A=255)
}

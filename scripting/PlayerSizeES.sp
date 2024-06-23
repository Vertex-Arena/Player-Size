#include <sourcemod>
#include <sdktools>

const char ADMIN_FLAG = ADMFLAG_RESERVATION; // Flag "a" for reserved slots

public Plugin myinfo = {
    name = "[IOS] PlayerSize",
    author = "inactivo",
    description = "Permite a los administradores cambiar el tamaño de su personaje",
    version = "1.0",
    url = "http://dsc.gg/vertexar"
};

public void OnPluginStart()
{
    RegAdminCmd("sm_playersize", Command_PlayerSize, ADMIN_FLAG, "Cambia el tamaño de tu personaje");
}

public Action Command_PlayerSize(int client, int args)
{
    Menu menu = new Menu(Handle_PlayerSizeMenu);
    menu.SetTitle("Selecciona tu tamaño:");
    menu.AddItem("Grande", "Grande");
    menu.AddItem("Normal", "Normal");
    menu.AddItem("Pequeño", "Pequeño");
    menu.Display(client, MENU_TIME_FOREVER);
    return Plugin_Handled;
}

public int Handle_PlayerSizeMenu(Menu menu, MenuAction action, int param1, int param2)
{
    if (action == MenuAction_Select)
    {
        char option[16];
        menu.GetItem(param2, option, sizeof(option));
        int scale;
        if (StrEqual(option, "Grande", false))
        {
            scale = 125;
        }
        else if (StrEqual(option, "Normal", false))
        {
            scale = 100;
        }
        else if (StrEqual(option, "Pequeño", false))
        {
            scale = 75;
        }
        SetPlayerScale(param1, scale);
        PrintToChat(param1, "\x04Tu tamaño ha sido cambiado a %s (%d%%).", option, scale);
    }
    return 0;
}

void SetPlayerScale(int client, int scale)
{
    char command[64];
    Format(command, sizeof(command), "mp_player_model_scale %d %d", GetClientUserId(client), scale);
    ServerCommand(command);
}
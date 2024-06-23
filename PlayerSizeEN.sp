#include <sourcemod>
#include <sdktools>

const char ADMIN_FLAG = ADMFLAG_RESERVATION; // Flag "a" for reserved slots

public Plugin myinfo = {
    name = "[IOS] PlayerSize",
    author = "inactivo",
    description = "Allows administrators to change their character size",
    version = "1.0",
    url = "http://dsc.gg/vertexar"
};

public void OnPluginStart()
{
    RegAdminCmd("sm_playersize", Command_PlayerSize, ADMIN_FLAG, "Change your character size");
}

public Action Command_PlayerSize(int client, int args)
{
    Menu menu = new Menu(Handle_PlayerSizeMenu);
    menu.SetTitle("Select your size:");
    menu.AddItem("Large", "Large");
    menu.AddItem("Normal", "Normal");
    menu.AddItem("Small", "Small");
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
        if (StrEqual(option, "Large", false))
        {
            scale = 125;
        }
        else if (StrEqual(option, "Normal", false))
        {
            scale = 100;
        }
        else if (StrEqual(option, "Small", false))
        {
            scale = 75;
        }
        SetPlayerScale(param1, scale);
        PrintToChat(param1, "\x04Your size has been changed to %s (%d%%).", option, scale);
    }
    return 0;
}

void SetPlayerScale(int client, int scale)
{
    char command[64];
    Format(command, sizeof(command), "mp_player_model_scale %d %d", GetClientUserId(client), scale);
    ServerCommand(command);
}
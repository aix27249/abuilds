#!/usr/bin/env python
# -*- coding: UTF-8 -*-

__license__ = """
Copyright 2010 Pável Varela Rodríguez <neonskull@gmail.com>
   
This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.
"""
__author__ = "Pável Varela Rodríguez <neonskull@gmail.com>"
__version__ = "0.1"


###############################
### EDIT THIS TO YOUR NEEDS ###
###############################

CONFIG = {
"Terminal": "sakura",
"Editor" : "medit",
"FileManager" : "pcmanfm",
"RunCommand" : "gmrun",
"ExitCommand" : "oblogout"
}

MY_GTK_MENU_BINARY="mygtkmenu"
MY_GTK_MENU_FILE="/tmp/myGtkMenu.txt"
ICONSIZE=-1       # Set to -1 to ignore icon
MENUPOS=(-1,-1)    # Set both to -1 to ignore position

#############################
### DO NOT EDIT FROM HERE ###
#############################
import os, re

OB_CFG_HOME = os.path.expanduser("~/.config/openbox")

DEFAULT_CFG = {
"Terminal": "xterm",
"Editor" : "gedit",
"FileManager" : "thunar",
"RunCommand" : "gmrun"
}

LANG={}
LANG["Long"] = os.environ["LANG"].split(".")[0]
LANG["Short"] = LANG["Long"].split("_")[0]


DOT_DESKTOP_LOCATIONS = [
"/usr/share/applications",
]

FILTERS = {
"dotDesktop": re.compile('.+\.desktop'),
"Categories": re.compile('Categories=.+'),
"Name": re.compile('Name(\[(en_US|en)\]|)=.+'),
"Exec": re.compile('Exec=.+'),
"Icon": re.compile('Icon=.+'),
}

CATEGORIES_PRIORITY = ["01System", "02Settings", "03Development", "04Education",
                       "05AudioVideo", "06Audio", "07Video", "08Office",
                       "09Graphics", "10Network", "11Utility", "12Viewer",
                       "13Game"]

MENU_TEMPLATE = """
MENU_TOP
SEPARATOR
MENU_ACCESORIES
MENU_GRAPHICS
MENU_EDUCATION
MENU_AUDIOVIDEO
MENU_OFFICE
MENU_GAMES
MENU_NETWORK
MENU_DEVEL
MENU_SETTINGS
MENU_SYSTEM
SEPARATOR
#submenu = Openbox Settings
#\ticon = NULL
#\tMENU_OPENBOX
EXIT
"""
MENU_TOP = """item=Terminal\ncmd="%s"\nicon=NULL\n
item=Editor\ncmd="%s"\nicon=NULL\n
item=FileManager\ncmd="%s"\nicon=NULL\n
item=Run\ncmd="%s"\nicon=NULL\n"""
MENU_CATEGORY = """submenu = %s\n\ticon = NULL\n%s\n\n"""
ITEM_ACTION = """\titem=%s\n\tcmd="%s"\n\ticon=%s\n\n"""
MENU = ""

LISTS = {
"accesories": {"categories": ["utility"], "label": "Accesories", "files": []},
"graphics": {"categories": ["graphics"], "label": "Graphics", "files": []},
"education": {"categories": ["education"], "label": "Education", "files": []},
"audiovideo": {"categories": ["audiovideo", "audio", "video"], "label": "Audio & Video", "files": []},
"office": {"categories": ["office"], "label": "Office", "files": []},
"games": {"categories": ["game"], "label": "Games", "files": []},
"network": {"categories": ["network"], "label": "Network", "files": []},
"devel": {"categories": ["development"], "label": "Development", "files": []},
"settings": {"categories": ["settings"], "label": "Settings", "files": []},
"system": {"categories": ["system"], "label": "System Tools", "files": []}
}


def getDotDesktopFiles():
    filelist = []
    for directory in DOT_DESKTOP_LOCATIONS:
        utf8_dir = directory.decode('utf8')
        filelist += [os.path.join(utf8_dir, item.decode('utf8'))
                         for item in os.listdir(directory)
                             if FILTERS["dotDesktop"].match(item)]
    return filelist


def __cleanValue(value):
    for to_clean in ["%U", "%u", "%F", "%f", "\n"]:
        value = value.replace(to_clean, "")
    value = value.replace("&", "&")
    value = value.strip()
    return value
    

def getName(content):
    for line in content:
         if FILTERS["Name"].match(line):
            return __cleanValue(line.split("=")[1])
    return None


def getCategory(content):
    for line in content:
        if FILTERS["Categories"].match(line):
            categories = [item.replace("\n", "") for item in line.split("=")[1].split(";")]
            for cat in CATEGORIES_PRIORITY:
                if cat[2:] in categories:
                    return __cleanValue(cat[2:])
    return None


def getExecCmd(content):
    for line in content:
        if FILTERS["Exec"].match(line):
            return __cleanValue(line.split("=")[1])
    return None


def getIcon(content):
    if ICONSIZE > 0:
        for line in content:
             if FILTERS["Icon"].match(line):
                return __cleanValue(line.split("=")[1])
    return "NULL"


def parseDotDesktopFile(filepath):
    content = open(filepath, "r").readlines()
    name = getName(content)
    category = getCategory(content)
    exec_cmd = getExecCmd(content)
    icon = getIcon(content)
    if None in [name, category, exec_cmd]:
        return None
    else:
        return {"Name": name,
                "Category": category,
                "Exec": exec_cmd,
                "Icon": icon}


def fillLists():
    files = getDotDesktopFiles()
    for currentFile in getDotDesktopFiles():
        info = parseDotDesktopFile(currentFile)
        if info:
            for category_list in LISTS.keys():
                if info["Category"].lower() in LISTS[category_list]["categories"]:
                    LISTS[category_list]["files"].append(info)


def __genMenuTop():
    for key in CONFIG.keys():
        if CONFIG[key]: DEFAULT_CFG[key] = CONFIG[key]
    return MENU_TOP % (DEFAULT_CFG["Terminal"],
                       DEFAULT_CFG["Editor"],
                       DEFAULT_CFG["FileManager"],
                       DEFAULT_CFG["RunCommand"])


def __genCategoryMenu(category):
    items = ""
    LISTS[category]["files"].sort()
    for item in LISTS[category]["files"]:
        items += ITEM_ACTION % (item["Name"], item["Exec"], item["Icon"])
    if not items:
        return ""
    menu_label = LISTS[category]["label"]
    return MENU_CATEGORY % (menu_label, items)


def __genMenuOpenbox():
    items = ""
    AUTOSTARTSH = os.path.join(OB_CFG_HOME, "autostart.sh")
    if not os.path.exists(AUTOSTARTSH):
        f = open(AUTOSTARTSH, "w")
        f.close()
        os.chmod(AUTOSTARTSH, 0744)
    items += ITEM_ACTION[8:] % ("Configure Autostarted Applications", "%s %s" % (DEFAULT_CFG["Editor"], AUTOSTARTSH))
    for item in LISTS["settings"]["files"]:
        if item["Exec"] in ["obconf"]:
            items += ITEM_ACTION[:-1] % (item["Name"], item["Exec"], item["Icon"])
    return items


def __genMenu():
    fillLists()
    
    MENU = MENU_TEMPLATE.replace("MENU_TOP", __genMenuTop())
    
    for category in LISTS.keys():
        MENU = MENU.replace("MENU_%s" % category.upper(), __genCategoryMenu(category))
    
    #MENU = MENU.replace("MENU_OPENBOX", __genMenuOpenbox())
    
    MENU = MENU.replace("EXIT", "\nitem=Exit\ncmd=%s\nicon=NULL\n" % CONFIG["ExitCommand"])

    if ICONSIZE > 0:
        MENU = "iconsize = %d\n%s" % (ICONSIZE, MENU)
    
    if MENUPOS[0] > 0 and MENUPOS[1] > 0:
        MENU = "MenuPosition =  %d %d\n%s" % (MENUPOS[0], MENUPOS[1], MENU)

    return MENU



def __writeMenuFile(content):
    filePath = os.path.join("/tmp", MY_GTK_MENU_FILE)
    menuFile = open(filePath, "w")
    menuFile.write(content)
    menuFile.close()


if __name__ == "__main__":
    if len(os.sys.argv) > 2:
        print("Bad arguments length!!")
    elif "--help" in os.sys.argv or "-h" in os.sys.argv:
        print "La ayuda"
    elif len(os.sys.argv) == 1:
        menu = __genMenu() 
        #print(menu)
        __writeMenuFile(menu)
        os.system("%s %s" % (MY_GTK_MENU_BINARY, MY_GTK_MENU_FILE))
    else:
        print("Argument error: %s" % " ".join(os.sys.argv[1:]))
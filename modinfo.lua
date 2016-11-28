name = "AFK Detection"
description = "Stops hunger decreasing, being killed my darkness when AFK"
author = "Ninja101"
version = "1.6.1"
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
client_only_mod = false
all_clients_require_mod = false

api_version = 10

configuration_options =
{
	{
		name = "afk_time",
		label = "Time To Mark As AFK",
		options =
		{
			{description = "30 seconds", data = 30},
			{description = "1 minute", data = 60},
			{description = "2 minutes", data = 120},
			{description = "3 minutes", data = 180},
			{description = "5 minutes", data = 300}
		},
		default = 120
	},
	{
		name = "max_afk_time",
		label = "Maximum Time Spent AFK",
		options =
		{
			{description = "No Limit", data = 0},
			{description = "1 minute", data = 60},
			{description = "2 minutes", data = 120},
			{description = "3 minutes", data = 180},
			{description = "5 minutes", data = 300},
			{description = "10 minutes", data = 600},
			{description = "15 minutes", data = 900},
			{description = "30 minutes", data = 1800}
		},
		default = 0
	},
	{
		name = "max_afk_action",
		label = "Action on Maximum AFK Time",
		options =
		{
			{description = "Disable AFK Immunity", data = 1},
			{description = "Kick Player", data = 2}
		},
		default = 1
	},
	{
		name = "host_immunity",
		label = "Admin Immunity",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true}
		},
		default = true
	},
	{
		name = "hunger_decrease",
		label = "Prevent Hunger Decrease",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true}
		},
		default = true
	},
	{
		name = "stop_death",
		label = "Prevent Death",
		options =
		{
			{description = "Off", data = false},
			{description = "On", data = true}
		},
		default = true
	},
}
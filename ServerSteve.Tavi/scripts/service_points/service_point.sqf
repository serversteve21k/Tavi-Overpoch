/*
	Vehicle Service Point by Axe Cop
	Rewritten for single currency, gems, briefcase support and 1.0.6 epoch compatibility by salival
	
	Requires DayZ Epoch 1.0.6.1

	This version adds support for both single currency and gems (from the epoch 1.0.6 update) as well as the original epoch briefcase currency system. 
	Instead of pricing things like the original way, prices are now done on a "worth" similar to how coins are done. The price value of items are below.
	
	1 silver = 1 worth
	1 10oz silver = 10 worth
	1 gold = 100 worth
	1 10oz gold = 1,000 worth
	1 briefcase = 10,000 worth

	Please see dayz_code\configVariables.sqf for the value of gems (DZE_GemWorthArray) and their relevant worth if they are enabled.

	Example config settings for _refuel_costs, _repair_costs and _rearm_costs:

	All 3 sections can either be made free, disabled or a specifc price with the following examples:

	["Air","free"] will make the vehicle config class of "Air" free for the specific action.
	["Air","disabled"] will make the vehicle config class of "Air" disabled for the specific action.
	["Air",2000] will make the vehicle config class of "Air" have a worth of 2000 for the specific action.
	["Armored_SUV_PMC",2000] will make the specific vehicle have a worth of 2000 for the specific action.
	["Armored_SUV_PMC","free"] will make the specific vehicle be free for the specific action.
	["Armored_SUV_PMC","disabled"] will make the specific vehicle be disabled for the specific action.

	Valid vehicle config classes as an example: "Air", "AllVehicles", "All", "APC", "Bicycle", "Car", "Helicopter", "Land", "Motorcycle", "Plane", "Ship", "Tank"
*/

private ["_folder","_servicePointClasses","_maxDistance","_actionTitleFormat","_actionCostsFormat","_message","_messageShown","_refuel_enable","_refuel_costs","_refuel_updateInterval","_refuel_amount","_repair_enable","_repair_costs","_repair_repairTime","_rearm_enable","_rearm_defaultcost","_rearm_costs","_rearm_magazineCount","_lastVehicle","_lastRole","_fnc_removeActions","_fnc_getCostsWep","_fnc_getCostsWep","_fnc_actionTitle","_fnc_isArmed","_fnc_getWeapons","_rearm_ignore","_cycleTime","_servicePoints","_vehicle","_role","_costs","_actionTitle","_weapons","_weaponName"];

// ---------------- CONFIG START ----------------

diag_log "Service Points: loading config...";

// general settings
_folder = "scripts\service_points\"; // folder where the service point scripts are saved, relative to the mission file
_servicePointClasses = ["Map_A_FuelStation_Feed","Land_A_FuelStation_Feed","FuelPump_DZ"]; // service point classes, You can also use dayz_fuelpumparray by its self for all the default fuel pumps.
_maxDistance = 50; // maximum distance from a service point for the options to be shown
_actionTitleFormat = "%1 (%2)"; // text of the vehicle menu, %1 = action name (Refuel, Repair, Rearm), %2 = costs (see format below)
_actionCostsFormat = "%2 %1"; // %1 = item name, %2 = item count
_message = "Vehicle Service Point nearby"; // message to be shown when in range of a service point (set to "" to disable)
_cycleTime = 5; // Time in sections for how often the action menu will be refreshed and how often it will search for a nearby fuel station (setting this too low can make a lot of lag)

// refuel settings
_refuel_enable = true; // enable or disable the refuel option
_refuel_costs = [
	["Land","free"], // All land vehicles are free to refuel. Free has to be in ""
	["Air",1000]	//1000 worth is 1 10oz gold for all air vehicles
];
_refuel_updateInterval = 1; // update interval (in seconds)
_refuel_amount = 0.05; // amount of fuel to add with every update (in percent)

// repair settings
_repair_enable = true; // enable or disable the repair option
_repair_repairTime = 1; // time needed to repair each damaged part (in seconds)
_repair_costs = [
	["Air",4000], // 4000 worth is 4 10oz gold.
	["AllVehicles",2000] // 2000 worth is 2 10oz gold for all other vehicles
];

// rearm settings
_rearm_enable = true; // enable or disable the rearm option
_rearm_defaultcost = 10000; // Default cost to rearm a weapon. (10000 worth == 1 briefcase)
_rearm_magazineCount = 2; // amount of magazines to be added to the vehicle weapon
_rearm_ignore = ["Horn","Laser Marker"]; // Array of weapon display names that are ignored in the rearm listing.

/*
	_ream_costs is an array based on the AMMO type. I.e M240, MK19, PKM, PKT, M134 etc. 
	You can disable certain ammo types from being able to be rearmed by making the price "disabled" 
	example: ["M134","disabled"]
*/

_rearm_costs = [
	["Flares",2000],
	["M240",5000],
	["PKM",5000],
	["PKT",5000]
];

// ---------------- CONFIG END ----------------

_lastVehicle = objNull;
_lastRole = [];
_messageShown = false;

SP_refuel_action = -1;
SP_repair_action = -1;
SP_rearm_actions = [];

_fnc_removeActions = {
	if (isNull _lastVehicle) exitWith {};
	_lastVehicle removeAction SP_refuel_action;
	SP_refuel_action = -1;
	_lastVehicle removeAction SP_repair_action;
	SP_repair_action = -1;
	{
		_lastVehicle removeAction _x;
	} forEach SP_rearm_actions;
	SP_rearm_actions = [];
	_lastVehicle = objNull;
	_lastRole = [];
};

_fnc_getCosts = {
	private ["_getVehicle","_getCosts","_cost","_getTypeName"];
	_getVehicle = _this select 0;
	_getCosts = _this select 1;
	_cost = [];
	{
		_getTypeName = _x select 0;
		if (_getVehicle isKindOf _getTypeName) exitWith {
			_cost = _x select 1;
		};
	} forEach _getCosts;
	_cost
};

_fnc_getCostsWep = {
	private ["_weapon","_getCostsWep","_returnCostWep","_typeName"];
	_weapon = _this select 0;
	_getCostsWep = _this select 1;
	_returnCostWep = _rearm_defaultcost;
	{
		_typeName = _x select 0;
		if (_weapon == _typeName) exitWith {
			_returnCostWep = _x select 1;
		};
	} forEach _getCostsWep;
	_returnCostWep
};

_fnc_actionTitle = {
	private ["_actionName","_actionCosts","_costsText","_return"];
	_actionName = _this select 0;
	_actionCosts = _this select 1;
	if (typeName _actionCosts == "STRING") then {
		_costsText = _actionCosts; 
	} else {
		_costsText = if (Z_SingleCurrency) then {format ["%1 %2",[_actionCosts] call BIS_fnc_numberText,CurrencyName]} else {format ["%1",[_actionCosts,true] call z_calcCurrency]};
	};
	_return = format [_actionTitleFormat,_actionName,_costsText];
	_return
};

_fnc_getWeapons = {
	private ["_gWeaponsVehicle","_gWeaponsRole","_gWeapons","_gWeaponName","_gTurret","_gWeaponsTurret"];
	_gWeaponsVehicle = _this select 0;
	_gWeaponsRole = _this select 1;
	_gWeapons = [];
	if (count _gWeaponsRole > 1) then {
		_gTurret = _gWeaponsRole select 1;
		_gWeaponsTurret = _gWeaponsVehicle weaponsTurret _gTurret;
		{
			_gWeaponName = getText (configFile >> "CfgWeapons" >> _x >> "displayName");
			if !(_gWeaponName in _rearm_ignore) then {
				_gWeapons set [count _gWeapons, [_x,_gWeaponName,_gTurret]];
			}; 
		} forEach _gWeaponsTurret;
	};
	_gWeapons
};

while {true} do {
	_vehicle = vehicle player;
	if (_vehicle != player) then {
		_servicePoints = (nearestObjects [getPosATL _vehicle,_servicePointClasses,_maxDistance]) - [_vehicle];
		if (count _servicePoints > 0) then {
			if (assignedDriver _vehicle == player) then {
				_role = ["Driver", [-1]];
			} else {
				_role = assignedVehicleRole player;
			};
			if (((str _role) != (str _lastRole)) || {_vehicle != _lastVehicle}) then {
				call _fnc_removeActions;
			};
			_lastVehicle = _vehicle;
			_lastRole = _role;
			if ((SP_refuel_action < 0) && {_refuel_enable}) then {
				_costs = [_vehicle,_refuel_costs] call _fnc_getCosts;
				_actionTitle = ["Refuel",_costs] call _fnc_actionTitle;
				SP_refuel_action = _vehicle addAction [_actionTitle,_folder + "service_point_actions.sqf",["refuel",_costs,_refuel_updateInterval,_refuel_amount],-1,false,true];
			};
			if ((SP_repair_action < 0) && {_repair_enable}) then {
				_costs = [_vehicle,_repair_costs] call _fnc_getCosts;
				_actionTitle = ["Repair",_costs] call _fnc_actionTitle;
				SP_repair_action = _vehicle addAction [_actionTitle,_folder + "service_point_actions.sqf",["repair",_costs,_repair_repairTime],-1,false,true];
			};
			if ((count _role > 1) && {count SP_rearm_actions == 0} && {_rearm_enable}) then {
				_weapons = [_vehicle,_role] call _fnc_getWeapons;
				{
					_weaponName = _x select 1;
					_costs = [_weaponName,_rearm_costs] call _fnc_getCostsWep;
					_actionTitle = [format["Rearm %1",_weaponName],_costs] call _fnc_actionTitle;
					SP_rearm_action = _vehicle addAction [_actionTitle,_folder + "service_point_actions.sqf",["rearm",_costs,_rearm_magazineCount,_x],-1,false,true];
					SP_rearm_actions set [count SP_rearm_actions, SP_rearm_action];
				} forEach _weapons;
			};
			if (!_messageShown && {_message != ""}) then {
				_messageShown = true;
				_vehicle vehicleChat _message;
			};
		} else {
			call _fnc_removeActions;
			_messageShown = false;
		};
	} else {
		call _fnc_removeActions;
		_messageShown = false;
	};
	uiSleep _cycleTime;
};

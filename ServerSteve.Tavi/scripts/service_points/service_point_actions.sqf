// Vehicle Service Point (Rearm) by Axe Cop
// Rewritten for single currency, gems, briefcase support and 1.0.6 epoch compatibility by salival
// Requires DayZ Epoch 1.0.6 for gem support.

private ["_vehicle","_costs","_fuel","_magazineCount","_weapon","_type","_name","_weaponType","_weaponName","_turret","_magazines","_ammo","_textMissing","_pos","_message","_action","_partName","_damage","_selection","_strH","_disabled","_amount","_enoughMoney","_moneyInfo","_wealth","_success","_reason"];

_vehicle = _this select 0;

_ammo = "";
_reason = "";

_action = (_this select 3) select 0;

_type = typeOf _vehicle;
_disabled = false;
_name = getText(configFile >> "cfgVehicles" >> _type >> "displayName");

_amount = (_this select 3) select 1;

if (_action == "rearm") then {
	_magazineCount = (_this select 3) select 2;
	_weapon = (_this select 3) select 3;
	
	_weaponType = _weapon select 0;
	_weaponName = _weapon select 1;
};

if (typeName _amount == "STRING") then {
	if ((_amount == "disabled") && {_action == "rearm"}) then {_reason = format["%1 is unable to be rearmed.",_weaponName]; _disabled = true};
	if ((_amount == "disabled") && {_action == "repair"}) then {_reason = format["%1 is unable to be repaired.",_name]; _disabled = true};
	if ((_amount == "disabled") && {_action == "refuel"}) then {_reason = format["%1 is unable to be refueled.",_name]; _disabled = true};
	if (_amount == "free") then {_amount = 0};
};

if (_disabled) exitWith {[_reason,1] call dayz_rollingMessages};

_enoughMoney = false;
_moneyInfo = [false, [], [], [], 0];
_wealth = player getVariable[Z_MoneyVariable,0];

if (Z_SingleCurrency) then {
	_enoughMoney = (_wealth >= _amount);
} else {
	Z_Selling = false;
	if (Z_AllowTakingMoneyFromVehicle) then {false call Z_checkCloseVehicle};
	_moneyInfo = _amount call Z_canAfford;
	_enoughMoney = _moneyInfo select 0;
};

_success = if (Z_SingleCurrency) then {true} else {[player,_amount,_moneyInfo,true,0] call Z_payDefault};

if (!_success && {_enoughMoney}) exitWith {systemChat localize "STR_EPOCH_TRADE_GEAR_AND_BAG_FULL"}; // Not enough room in gear or bag to accept change

if (_enoughMoney) then {
	_success = if (Z_SingleCurrency) then {_amount <= _wealth} else {[player,_amount,_moneyInfo,false,0] call Z_payDefault};
	if (_success) then {
		if (Z_SingleCurrency) then {
			player setVariable[Z_MoneyVariable,(_wealth - _amount),true];
		};
		[player,50,true,getPosATL player] spawn player_alertZombies;
		if (_action == "refuel") then {
			[player,50,true,getPosATL player] spawn player_alertZombies;
			_vehicle engineOn false;
			[format["Refueling %1...",_name],1] call dayz_rollingMessages;
			[_vehicle,"refuel",0,false] call dayz_zombieSpeak;

			while {vehicle player == _vehicle} do {
				if ([0,0,0] distance (velocity _vehicle) > 1) exitWith {[format["Refueling of %1 stopped",_name],1] call dayz_rollingMessages};
				_fuel = (fuel _vehicle) + ((_this select 3) select 3);
				if (_fuel > 0.99) exitWith {
					_vehicle setFuel 1;
					[format["%1 Refueled",_name],1] call dayz_rollingMessages;
				};
				_vehicle setFuel _fuel;
				uiSleep ((_this select 3) select 2);
			};
		};
		if (_action == "repair") then {
			_vehicle engineOn false;
			[_vehicle,"repair",0,false] call dayz_zombieSpeak;

			_hitpoints = _vehicle call vehicle_getHitpoints;
			_allRepaired = true;
			{
				if ((vehicle player != _vehicle) || {[0,0,0] distance (velocity _vehicle) > 1}) exitWith {
					_allRepaired = false;
					[format["Repairing of %1 stopped",_name],1] call dayz_rollingMessages;
				};
				_damage = [_vehicle,_x] call object_getHit;
				if (_damage > 0) then {
					_partName = toArray _x;
					_partName set [0,20];
					_partName set [1,45];
					_partName set [2,20];
					_partName = toString _partName;
					[format ["Repairing%1...",_partName],1] call dayz_rollingMessages;
					_selection = getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _x >> "name");
					_strH = "hit_" + (_selection);
					_vehicle setHit[_selection,0];
					_vehicle setVariable [_strH,0,true];
					uiSleep ((_this select 3) select 2);
				};
			} forEach _hitpoints;
			PVDZ_veh_Save = [_vehicle,"repair"];
			publicVariableServer "PVDZ_veh_Save";

			if (_allRepaired) then {
				_vehicle setDamage 0;
				_vehicle setVelocity [0,0,1];
				[format["%1 Repaired",_name],1] call dayz_rollingMessages;
			};
		};

		if (_action == "rearm") then {
			_turret = _weapon select 2;
			_magazines = getArray (configFile >> "CfgWeapons" >> _weaponType >> "magazines");
			_ammo = _magazines select 0;

			_magazines = _vehicle magazinesTurret _turret;
			{_vehicle removeMagazineTurret [_ammo,_turret];} forEach _magazines;

			for "_i" from 1 to _magazineCount do {_vehicle addMagazineTurret [_ammo,_turret];};

			[format["%1 of %2 Rearmed",_weaponName,_name],1] call dayz_rollingMessages;
		};
		call player_forceSave;
	} else {
		systemChat localize "STR_EPOCH_TRADE_DEBUG";
	};
} else {
	_itemText = if (Z_SingleCurrency) then {CurrencyName} else {[_amount,true] call z_calcCurrency};
	if (Z_SingleCurrency) then {
		systemChat format ["You need %1 %2 to %3 your %4.",[_amount] call BIS_fnc_numberText,_itemText,_action,_name];
	} else {
		systemChat format ["You need %1 to %2 your %3.",_itemText,_action,_name];
	};
};

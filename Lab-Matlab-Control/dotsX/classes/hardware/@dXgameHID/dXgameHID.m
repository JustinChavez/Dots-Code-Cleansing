function [g_, attributes_, batchMethods_] = dXgameHID(num_objects)% function [g_, attributes_, batchMethods_] = dXgameHID(num_objects)%% Constructor method for class dXgameHID%   DotsX interface to USB HID gamepads%% Input:%   num_objects     ... ignored -- always creates just one%% Output:%   g_              ... created object%   attributes_     ... default object attributes%   batchMethods_   ... methods that can be run in a batch (e.g., draw)% Copyright 2007 Benjamin Heasly%   University of Pennsylvaniaglobal ROOT_STRUCT% look for mex functionavailable = exist('HIDx') == 3;% return empty matrix if not available, which% will automatically remove gameHID devices from the ui queue% if called from rInitif isfield(ROOT_STRUCT, 'dXgameHID') || ~available    g_            = [];    attributes_   = [];    batchMethods_ = [];    returnend% how to find compatible deviceHIDCriteria.usageName = 'GamePad';% default channelizer.%   use raw values from each element%   feebly guess at the number of elements: 8n = 8;[HIDChannelizer(1:n).gain] = deal(1);[HIDChannelizer(1:n).offset] = deal(0);[HIDChannelizer(1:n).high] = deal(nan);[HIDChannelizer(1:n).low] = deal(nan);[HIDChannelizer(1:n).delta] = deal(0);[HIDChannelizer(1:n).freq] = deal(1);% default object attributesattributes = { ...    % name          type        ranges(?)	default    'available',	'boolean',  [],         available; ...    'active',       'boolean',  [],         false; ...    'FIRAdataType', 'string',   [],         'gameHIDData'; ...    'HIDClass',     'string',   [],         'dXgameHID'; ...    'HIDCriteria',  'struct',   [],         HIDCriteria; ...    'HIDChannelizer','struct',  [],         HIDChannelizer; ...    'HIDIndex',     'scalar',   [],         nan; ...    'HIDDeviceInfo','struct',   [],         []; ...    'HIDElementsInfo','struct', [],         []; ...    'mappings',     'cell',     [],         {};...    'offsetTime',   'auto',     [],         0; ...    'default',      'auto',     [],         []; ...    'other',        'auto',     [],         []; ...    'checkList',    'auto',     [],         []; ...    'checkRet',     'auto',     [],         []; ...    'values',       'auto',     [],         []; ...    'recentVal',    'auto',     [],         1};% make an array of objects from structs made from the attributesg_ = class(cell2struct(attributes(:,4), attributes(:,1), 1), 'dXgameHID');% return the attributes, if necessaryif nargout > 1    attributes_ = attributes;end% return list of batch methodsif nargout > 2    batchMethods_ = {'reset', 'saveToFIRA', 'root', 'getJump'};end
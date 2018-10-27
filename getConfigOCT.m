function config = getConfigOCT(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getConfig makes the parameters structure config for the OCT machine
% 
% Call:
%       config = getConfig()    return the default settings
%
%       config = getConfig(<field_name>, <field_value>) return the default
%       settings except the vaiables named 'field_name' are set as 'field_value'
%
% author: Mingchuan Zhou    03/06/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the real imaging region in OCT in x axis
default_x_region = 3;%4;%

% the real imaging region in OCT in y axis
default_y_region = 2.62;%4;%*2.80/3;%62;%3

% the real imaging region in OCT in z axis
default_z_region = 2;

% the real imaging region in OCT in z axis
default_x_pixel_num = 128;

% the real imaging region in OCT in z axis
default_y_pixel_num = 512;

% the real imaging region in OCT in z axis
default_z_pixel_num = 1024;

%the size of the needle
default_needle_diameter = 0.31;%0.3512;

%the size of the needle
default_needle_bevel = 15*pi/180;

%% input arguments parse
pp              = inputParser;
checkfloat      = @(x) validateattributes(x, {'double', 'single'}, {'scalar'});
addOptional(pp, 'x_region',   	default_x_region,     checkfloat );
addOptional(pp, 'y_region',   	default_y_region,     checkfloat );
addOptional(pp, 'z_region',   	default_z_region,     checkfloat );
addOptional(pp, 'x_pixel_num',   	default_x_pixel_num,     checkfloat );
addOptional(pp, 'y_pixel_num',   	default_y_pixel_num,     checkfloat );
addOptional(pp, 'z_pixel_num',   	default_z_pixel_num,     checkfloat );
addOptional(pp, 'needle_diameter',   	default_needle_diameter,     checkfloat );
addOptional(pp, 'needle_bevel',   	default_needle_bevel,     checkfloat );

pp.KeepUnmatched = true;
parse(pp, varargin{:});

x_region             = pp.Results.x_region;
y_region             = pp.Results.y_region;
z_region             = pp.Results.z_region;
x_pixel_num          = pp.Results.x_pixel_num;
y_pixel_num          = pp.Results.y_pixel_num;
z_pixel_num          = pp.Results.z_pixel_num;
needle_diameter          = pp.Results.needle_diameter;
needle_bevel = pp.Results.needle_bevel;


config.x_region        = x_region;
config.y_region        = y_region;
config.z_region        = z_region;
config.x_pixel_num     = x_pixel_num;
config.y_pixel_num     = y_pixel_num;
config.z_pixel_num     = z_pixel_num;
config.needle_diameter = needle_diameter;
config.needle_bevel = needle_bevel;
config.x_reslution     = x_region/x_pixel_num;
config.y_reslution     = y_region/y_pixel_num;
config.z_reslution     = z_region/z_pixel_num;

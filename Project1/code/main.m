close all;
clear all;
clc;

%% Setup files

name_motion={'Walking'    'Jogging'   'Crouch'};
name_grf   ={'Walking_FP' 'Jogging_FP' 'Crouch_FP'};

index = 1; % select the motion to be loaded and visualized e.g., index=1 -> NormWalk

%% Read data (data files should be in the same folder as the .m file)

file_dir = pwd;
data_trc = readtable(fullfile(file_dir,[name_motion{index} '.csv']));
data_grf = readtable(fullfile(file_dir,[name_grf{index} '.csv']));


%% Downsample ground reaction data, so it has the same length as marker trajectory

data_grf_s = downsample(data_grf,10);
time=data_grf_s.Time;

%% Assign the uploaded table to variables in MATLAB
toMeters = 1/1000; % data is originally in mm, it has to be divided by 1000 to have it in meters

% Thorax origin
TRXO_y = data_trc.TRXO_Y * toMeters; % horizontal coordinate of the thorax origin
TRXO_z = data_trc.TRXO_Z * toMeters; % vertical coordinate of the thorax origin

% Thorax proximal
TRXP_y = data_trc.TRXP_Y * toMeters; % horizontal coordinate of the thorax proximal
TRXP_z = data_trc.TRXP_Z * toMeters; % vertical coordinate of the thorax proximal

% Pelvis proximal
PELP_y = data_trc.PELP_Y * toMeters; % horizontal coordinate of the pelvis proximal
PELP_z = data_trc.PELP_Z * toMeters; % vertical coordinate of the pelvis proximal

% Pelvis origin
PELO_y = data_trc.PELO_Y * toMeters; % horizontal coordinate of the pelvis origin
PELO_z = data_trc.PELO_Z * toMeters; % vertical coordinate of the pelvis origin

% Right hip
RHJC_y = data_trc.RHJC_Y * toMeters; % horizontal coordinate of the right hip
RHJC_z = data_trc.RHJC_Z * toMeters; % vertical coordinate of the right hip

% Left hip
LHJC_y = data_trc.LHJC_Y * toMeters; % horizontal coordinate of the left hip
LHJC_z = data_trc.LHJC_Z * toMeters; % vertical coordinate of the left hip

% Right knee
RKJC_y = data_trc.RKJC_Y * toMeters; % horizontal coordinate of the right knee
RKJC_z = data_trc.RKJC_Z * toMeters; % vertical coordinate of the right knee

% Left knee
LKJC_y = data_trc.LKJC_Y * toMeters; % horizontal coordinate of the left knee
LKJC_z = data_trc.LKJC_Z * toMeters; % vertical coordinate of the left knee

% Right ankle
RAJC_y = data_trc.RAJC_Y * toMeters; % horizontal coordinate of the right ankle
RAJC_z = data_trc.RAJC_Z * toMeters; % vertical coordinate of the right ankle

% Left ankle
LAJC_y = data_trc.LAJC_Y * toMeters; % horizontal coordinate of the left ankle
LAJC_z = data_trc.LAJC_Z * toMeters; % vertical coordinate of the left ankle

% Right toe
RTOO_y = data_trc.RTOO_Y * toMeters; % horizontal coordinate of the right toe
RTOO_z = data_trc.RTOO_Z * toMeters; % vertical coordinate of the right toe

% Left toe
LTOO_y = data_trc.LTOO_Y * toMeters; % horizontal coordinate of the left toe
LTOO_z = data_trc.LTOO_Z * toMeters; % vertical coordinate of the left toe 

% FP1
FP1_force_y = data_grf_s.FP1_Force_Y; % horizontal coordinate of the ground reaction force in FP1
FP1_force_z = data_grf_s.FP1_Force_Z; % vertical coordinate of the ground reaction force in FP1
FP1_COP_y = (600 - data_grf_s.FP1_COP_Y) * toMeters; % horizontal coordinate of the COP in FP1
FP1_COP_z = data_grf_s.FP1_COP_Z * toMeters; % vertical coordinate of the COP in FP1

% FP2
FP2_force_y = data_grf_s.FP2_Force_Y; % horizontal coordinate of the ground reaction force in FP2
FP2_force_z = data_grf_s.FP2_Force_Z; % vertical coordinate of the ground reaction force in FP2
FP2_COP_y = (-600 - data_grf_s.FP2_COP_Y) * toMeters; % horizontal coordinate of the COP in FP2
FP2_COP_z = data_grf_s.FP2_COP_Z*toMeters; % vertical coordinate of the COP in FP2

%% Run a simple animation for visualization purposes only

run_animation = true;
color_body = "#0077be";
row = height(data_trc);

if run_animation == true
    figure('color','w','Position', [10 10 1200 700]);

    % Start from frame 50th as the coordinates at the first few frames werenot processed and they are not considered in the assignment

    for i=1:1:row

        % Plots the lines of the body parts
        subplot(1,1,1)
        plot([TRXO_y(i),TRXP_y(i)],[TRXO_z(i),TRXP_z(i)],'Color', color_body, 'LineWidth', 2)  % TRXO - TRXP segmemt
        hold on;
        plot([PELO_y(i),PELP_y(i)],[PELO_z(i),PELP_z(i)],'Color', color_body, 'LineWidth', 2)  % PELO - PELP segmemt
        plot([RHJC_y(i),RKJC_y(i)],[RHJC_z(i),RKJC_z(i)],'Color', color_body, 'LineWidth', 2)  % R hip - R knee segmemt
        plot([LHJC_y(i),LKJC_y(i)],[LHJC_z(i),LKJC_z(i)],'Color', color_body, 'LineWidth', 2)  % L hip - L knee segmemt
        plot([RAJC_y(i),RKJC_y(i)],[RAJC_z(i),RKJC_z(i)],'Color', 'g', 'LineWidth', 2)         % R ankle - R knee segmemt
        plot([LAJC_y(i),LKJC_y(i)],[LAJC_z(i),LKJC_z(i)],'Color', 'r', 'LineWidth', 2)         % L ankle - L knee segmemt
        plot([RAJC_y(i), RTOO_y(i)],[RAJC_z(i),RTOO_z(i)],'Color', color_body, 'LineWidth', 2) % R ankle - R toe segmemt
        plot([LAJC_y(i),LTOO_y(i)],[LAJC_z(i),LTOO_z(i)],'Color', color_body, 'LineWidth', 2)  % L ankle - L knee segmemt

        % Plots the text for the name of the joints
        %text(RHJC_y(i), RHJC_z(i),'R hip', 'FontSize', 8)
        %text(LHJC_y(i),LHJC_z(i),'L hip', 'FontSize', 8)
        %text(RKJC_y(i),RKJC_z(i),'R knee', 'FontSize', 8)
        %text(LKJC_y(i),LKJC_z(i),'L knee', 'FontSize', 8)
        %text(RAJC_y(i),RAJC_z(i),'R ankle', 'FontSize', 8)
        %text(LAJC_y(i),LAJC_z(i),'L ankle', 'FontSize', 8)

        % Plots the text for the angle of the joints
        %text(TRXO_y(i), TRXO_z(i), [num2str(trunk_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(PELO_y(i), PELO_z(i), [num2str(pelvis_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RHJC_y(i), RHJC_z(i), [num2str(hip_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RKJC_y(i), RKJC_z(i), [num2str(knee_right_angle(i), '%.1f') '°'], 'FontSize', 12)
        %text(RAJC_y(i), RAJC_z(i), [num2str(ankle_right_angle(i), '%.1f') '°'], 'FontSize', 12)

        % Compare with the previous frame, if the values of COP are changed, it
        % means the subject is stepping on that force plate and we visualize it
        if (i>=2)
            if FP1_COP_y(i) ~= FP1_COP_y(i-1)
                plot(FP1_COP_y(i),FP1_COP_z(i),'ok','LineWidth',2);
                quiver(FP1_COP_y(i),FP1_COP_z(i),FP1_force_y(i)/1000,FP1_force_z(i)/1000,0,'Color','r','LineWidth',2); % It is divided by 1000 for visualization purpose only
            end
            if FP2_COP_y(i) ~= FP2_COP_y(i-1)
                plot(FP2_COP_y(i),FP2_COP_z(i),'ok','LineWidth',2);
                quiver(FP2_COP_y(i),FP2_COP_z(i),FP2_force_y(i)/1000,FP2_force_z(i)/1000,0,'Color','r','LineWidth',2); % It is divided by 1000 for visualization purpose only
            end
        end

        hold off
        axis([-3.5 3.5 -0.25 3])
        xlabel("horizontal distance [m]",'FontSize',20); ylabel("vertical distance [m]",'FontSize',20)
        pause(0.1)
    end
end

%% Angle calculations

% Trunk
TRXO = [TRXO_y TRXO_z];
TRXP = [TRXP_y TRXP_z];
trunk_vec = TRXO - TRXP;
z_vec = [zeros(size(trunk_vec, 1), 1), ones(size(trunk_vec, 1), 1)]; % is [0 1] for every frame (which corresponds to the z-axis)

trunk_angle = atan2(cross_product(trunk_vec, z_vec), dot_product(trunk_vec, z_vec)) * 180/pi;

% Pelvis
PELP = [PELP_y PELP_z];
PELO = [PELO_y PELO_z];
pelvis_vec = PELP - PELO;
z_vec = [zeros(size(pelvis_vec, 1), 1), ones(size(pelvis_vec, 1), 1)]; % is [0 1] for every frame (which corresponds to the z-axis)

pelvis_angle = atan2(cross_product(pelvis_vec, z_vec), dot_product(pelvis_vec, z_vec)) * 180/pi;

% Hip (right leg)
right_knee = [RKJC_y RKJC_z];
right_hip =[RHJC_y RHJC_z];
femur_right_vec = right_hip - right_knee;

hip_angle = atan2(cross_product(pelvis_vec, femur_right_vec), dot_product(pelvis_vec, femur_right_vec)) * 180/pi;

% Knee (right leg)
right_ankle = [RAJC_y RAJC_z];
tibia_right_vec = right_knee - right_ankle;

knee_right_angle = atan2(cross_product(tibia_right_vec, femur_right_vec), dot_product(tibia_right_vec, femur_right_vec)) * 180/pi;

% Ankle
right_foot = [RTOO_y RTOO_z];
right_foot_vec = right_foot - right_ankle;

ankle_right_angle = 95 + atan2(cross_product(tibia_right_vec, right_foot_vec), dot_product(tibia_right_vec, right_foot_vec)) * 180/pi;



function cp = cross_product(a_vec, b_vec)
    cp = (a_vec(:, 1) .* b_vec(:, 2)) - (a_vec(:, 2) .* b_vec(:, 1));
end

function dp = dot_product(a_vec, b_vec)
    dp = (a_vec(:, 1) .* b_vec(:, 1)) + (a_vec(:, 2) .* b_vec(:, 2));
end

%% Moment
g=9.81;
total_mass=61.9;
total_length=1.77;
dt =( time(3) - time(2));

% ankle_speed_y = gradient(RANKLE_y,dt);
% ankle_acc_y = gradient(ankle_speed_y, dt);
% 
% ankle_speed_z = gradient(RANKLE_z,dt);
% ankle_acc_z = gradient(ankle_speed_z, dt);
% 
% ankle_angle_speed = gradient(foot_angle,dt);
% ankle_angle_acc = gradient(ankle_angle_speed,dt);
% 
ankle_angle_speed = diff(ankle_right_angle)/dt;
ankle_angle_acc = diff(ankle_angle_speed)/dt;

% foot_length = sqrt(Foot_right(160, 1)^2+Foot_right(160, 2)^2)
foot_length =0.152*total_length;%from ISBN 9780470398180
foot_COM_factor = 0.5;

ankle_speed_y = diff(RAJC_y)/dt;
ankle_acc_y = diff(ankle_speed_y)/dt;


ankle_speed_z = diff(RAJC_z)/dt;
ankle_acc_z = diff(ankle_speed_z)/dt;




knee_speed_y = diff(RKJC_y)/dt;
knee_acc_y = diff(knee_speed_y )/dt;

knee_speed_z = diff(RKJC_z)/dt;
knee_acc_z = diff(knee_speed_z)/dt;

knee_angle_speed = diff(knee_right_angle)/dt;
knee_angle_acc = diff(knee_angle_speed)/dt;




hip_angle_speed=diff(hip_angle)/dt;
hip_angle_acc = diff(hip_angle_speed)/dt;


%foot


CG_foot_y=mean([RTOO_y';RAJC_y']);
CG_foot_z=mean([RTOO_z';RAJC_z']);
dy_Af = CG_foot_y'-RAJC_y;
dz_Af = RAJC_z-CG_foot_z';
dz_Gf=CG_foot_z'-FP2_COP_z;
dy_Gf=FP2_COP_y-CG_foot_y';


CG_foot_speed_z = diff(CG_foot_z)/dt;
CG_foot_speed_y = diff(CG_foot_y)/dt;

CG_foot_acc_z = diff(CG_foot_speed_z)/dt;
CG_foot_acc_y = diff(CG_foot_speed_y)/dt;

m_f=total_mass*0.0145;
center_of_gyration_foot=foot_length*0.475;
I_foot=center_of_gyration_foot^2*m_f;

for i=124:212
    A1=[1 0 0;
        0 1 0; 
        -dz_Af(i) -dy_Af(i) 1
        ];

    b1=[m_f*CG_foot_acc_y(i)-FP2_force_y(i); 
        m_f*CG_foot_acc_z(i)-FP2_force_z(i)+m_f*g;
        I_foot*ankle_angle_acc(i)-(FP2_force_y(i)*dz_Gf(i)+FP2_force_z(i)*dy_Gf(i))];

    X1(:,i)=A1\b1;
end
M_foot=X1(3,124:212)';
P_foot=M_foot.*ankle_angle_speed(124:212);


%shank
m_s=0.0465*total_mass;
% shank_length=sqrt(shank_right(160,1)^2+shank_right(160,2)^2);
shank_length=(0.285-0.039)*total_length;
center_of_gyration_shank=0.302*shank_length;
I_shank=center_of_gyration_shank^2*m_s;



CG_shank_y=RAJC_y+0.433*(RKJC_y-RAJC_y);
CG_shank_z=RAJC_z+0.433*(RKJC_z-RAJC_z);

CG_shank_speed_z = diff(CG_shank_z)/dt;
CG_shank_speed_y = diff(CG_shank_y)/dt;

CG_shank_acc_z = diff(CG_shank_speed_z)/dt;
CG_shank_acc_y = diff(CG_shank_speed_y)/dt;
% CG_shank_y=mean([RKNEE_y';RANKLE_y'])';
% CG_shank_z=mean([RKNEE_z';RANKLE_z'])';

d_Ks_z=RKJC_z-CG_shank_z;
d_Ks_y=RKJC_y-CG_shank_y;
d_As_y=CG_shank_y-RAJC_y;
d_As_z=CG_shank_z-RAJC_z;




for i=124:212
A2=[1 0 0 ; 
    0 1 0; 
    -d_Ks_z(i) d_Ks_y(i) 1];

b2=[m_s*CG_shank_acc_y(i)+X1(1,i); 
    m_s*CG_shank_acc_z(i)+X1(2,i)+m_s*g ; 
    X1(3,i)+X1(1,i)*d_As_z(i)-X1(2,i)*d_As_y(i)+I_shank*knee_angle_acc(i)];

X2(:,i)=A2\b2;
end

%hip
m_t=0.1*total_mass;
thigh_length=(0.530-(0.285+0.039))*total_length;
center_of_gyration_thigh=0.323*thigh_length;
I_thigh=center_of_gyration_thigh^2*m_t;

CG_thigh_y=RKJC_y+0.433*(RHJC_y-RKJC_y);
CG_thigh_z=RKJC_z+0.433*(RHJC_z-RKJC_z);



CG_thigh_speed_z = diff(CG_thigh_z)/dt;
CG_thigh_speed_y = diff(CG_thigh_y)/dt;

CG_thigh_acc_z = diff(CG_thigh_speed_z)/dt;
CG_thigh_acc_y = diff(CG_thigh_speed_y)/dt;


d_Kt_z=CG_thigh_z-RKJC_z;
d_Kt_y=RKJC_y-CG_thigh_y;
d_Ht_y=CG_thigh_y-RHJC_y;
d_Ht_z=RHJC_z-CG_thigh_z;

for i=124:212
    A3=[1 0 0 ; 
        0 1 0; 
        -d_Ht_z(i) -d_Ht_y(i) 1];

    b3=[m_t*CG_thigh_acc_y(i)+X2(1,i); 
        m_t*CG_thigh_acc_z(i)+X2(2,i)+m_t*g ; 
        X2(3,i)+X2(1,i)*d_Kt_z(i)+X2(2,i)*d_Kt_y(i)+I_thigh*hip_angle_acc(i)];

    X3(:,i)=A3\b3;
end





%plots
subplot(3,2,1)
plot(time(124:257),trunk_angle(124:257)*180/pi,LineWidth=1.5)
title("Trunk angle")
xlabel("time / s")
ylabel("Trunk angle / deg")

subplot(3,2,2)
plot(time(124:257),pelvis_angle(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Pelvis angle / deg")
title("Pelvis angle")

subplot(3,2,3)
plot(time(124:257),hip_angle(124:257)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Hip angle / deg")
title("Hip angle")

subplot(3,2,4)
plot(time(124:212),knee_right_angle(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Knee angle / deg")
title("Knee angle")
legend("Right leg")

subplot(3,2,5)
plot(time(124:212),ankle_right_angle(124:212)*180/pi,LineWidth=1.5)
xlabel("time / s")
ylabel("Foot angle / deg")
title("foot angle")
legend("Right leg")

figure(2)
plot((124-124:212-124)*(100/(212-124)),X1(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(3)
plot((124-124:212-124)*(100/(212-124)),X2(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(4)
plot((124-124:212-124)*(100/(212-124)),X3(3,124:212)/(61.9))
xlabel("gait / %")
ylabel("moment / Nm/kg")

figure(5)
plot((124-124:212-124)*(100/(212-124)),P_foot/(61.9))
xlabel("gait / %")
ylabel("Power / W/kg")
% for i=124:257
% plot([RANKLE_y(i),RKNEE_y(i)],[RANKLE_z(i),RKNEE_z(i)])
% hold on
% plot(CG_shank_y(i),CG_shank_z(i),'*')
% pause(0.1)
% hold off
% end
